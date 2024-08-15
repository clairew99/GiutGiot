package com.gugucon.kiot.domain.clothes.service;

import com.gugucon.kiot.domain.clothes.dto.*;
import com.gugucon.kiot.domain.clothes.entity.Clothes;
import com.gugucon.kiot.domain.clothes.enums.Category;
import com.gugucon.kiot.domain.clothes.enums.Color;
import com.gugucon.kiot.domain.clothes.enums.Pattern;
import com.gugucon.kiot.domain.clothes.enums.Type;
import com.gugucon.kiot.domain.clothes.repository.ClothesRepository;
import com.gugucon.kiot.domain.coordinate.entity.Coordinate;
import com.gugucon.kiot.domain.coordinate.repository.CoordinateRepository;
import com.gugucon.kiot.domain.data.entity.Voice;
import com.gugucon.kiot.domain.data.repository.ActivityRepository;
import com.gugucon.kiot.domain.data.repository.VoiceRepository;
import com.gugucon.kiot.domain.member.entity.Member;
import com.gugucon.kiot.domain.member.repository.MemberRepository;
import com.gugucon.kiot.global.exception.BusinessLogicException;
import com.gugucon.kiot.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@Service
@RequiredArgsConstructor
@Transactional
public class ClothesService {

    private final ClothesRepository clothesRepository;
    private final CoordinateRepository coordinateRepository;
    private final VoiceRepository voiceRepository;
    private final ActivityRepository activityRepository;
    private final MemberRepository memberRepository;

    private final double criterion = 0.2;

    public ClothesAddRes addClothes(ClothesAddReq clothesAddReq, Long memberId) {

        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new BusinessLogicException(ErrorCode.NOT_FOUND));

        clothesAddReq.defaultSetting();

        Color enumColor = Color.valueOf(clothesAddReq.getColor().toUpperCase());
        Type enumType = Type.valueOf(clothesAddReq.getType().toUpperCase());
        Category enumCategory = Category.valueOf(clothesAddReq.getCategory().toUpperCase());
        Pattern enumPattern = Pattern.valueOf(clothesAddReq.getPattern().toUpperCase());

        Optional<Clothes> existingClothes = clothesRepository.findClothes(
                memberId,
                clothesAddReq.getIsTop(),
                enumColor,
                enumType,
                enumCategory,
                enumPattern
        );

        ClothesAddRes res = new ClothesAddRes();

        if (existingClothes.isEmpty()){
            Clothes clothes = clothesAddReq.toClothes(
                    member,
                    clothesAddReq.getIsTop(),
                    enumColor,
                    enumType,
                    enumCategory,
                    enumPattern);
            clothes.setWeight(calculateWeightOfClothes(clothes));
            res.setClothesId(clothesRepository.save(clothes).getId());
        } else {
            res.setClothesId(existingClothes.get().getId());
        }

        return res;
    }

    private double calculateWeightOfClothes(Clothes clothes) {

        double w = 1;

        Color color = clothes.getColor();

        w *= 5 * Math.exp(2 * color.getHue() * color.getBrightness() * color.getSaturation());
        w *= clothes.getPattern().getWeight();

        if (!clothes.getIsTop()) w -= 3;

        return 1 / w;
    }

    public ClothesDetailsRes findClothes(Long memberId, Long clothesId) {

        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new BusinessLogicException(ErrorCode.NOT_FOUND));

        Clothes clothes = clothesRepository.findById(clothesId)
                .orElseThrow(()->new BusinessLogicException(ErrorCode.NOT_FOUND));
        if (!clothes.getMember().getId().equals(memberId)){
            throw new BusinessLogicException(ErrorCode.NOT_MEMBER_CLOTHES);
        }

        Optional<LocalDate> lastworn = coordinateRepository.findLatestDateByMemberIdAndClothesId(memberId, clothesId);
        int conversationTime = 0;
        int conversationCount = 0;
        int walkingTime = 0;

        if (lastworn.isPresent()) {
            List<Voice> voices = voiceRepository.findByDate(memberId, lastworn.get());

            for (Voice voice : voices) {
                conversationTime += voice.getTime();
            }

            conversationCount += voices.size();

            walkingTime = activityRepository.findByDate(memberId, lastworn.get()).orElse(0);
        }

        double memory = calculateCurrentMemory(clothes, member);

        return ClothesDetailsRes.of(clothes, lastworn.orElse(null), conversationCount, conversationTime, walkingTime, memory, calculateLeftTime(clothes, member));
    }

    public ClothesMemoryListRes findClothesMemory(long memberId) {
        Member member = memberRepository.findById(memberId).
                orElseThrow(()->new BusinessLogicException(ErrorCode.NOT_FOUND));

        ClothesMemoryListRes res = new ClothesMemoryListRes();

        // 1. 일주일 안에 입은 코디를 조회한다
        LocalDate today = LocalDate.now();
        LocalDate aWeekAgo = today.minusWeeks(1);

        List<Coordinate> weekCoordinate = coordinateRepository.findCoordinateLastWeek(memberId, today, aWeekAgo);

        // 2. 최신순부터 코디 조회
        // 2-1. 코디 정렬
        Collections.sort(weekCoordinate, new Comparator<Coordinate>() {
            @Override
            public int compare(Coordinate c1, Coordinate c2) {
                // 내림차순 정렬
                return c2.getId().getDate().compareTo(c1.getId().getDate());
            }
        });

        Set<Long> clothesIds = new HashSet<>();
        for (Coordinate c: weekCoordinate){
            // 상의
            if (!clothesIds.contains(c.getTop().getId())){
                // 가중치 계산
                double memoryWeight = calculateCurrentMemory(c.getTop(), member);

                if (memoryWeight > criterion){ // 아직 기억에 남았다
                    res.getRememberedClothesList().add(ClothesDTO.of(c.getTop(), memoryWeight));
                }else{
                    res.getForgottenClothesList().add(ClothesDTO.of(c.getTop(), memoryWeight));
                }
                clothesIds.add(c.getTop().getId());

            }
            // 하의
            if (!clothesIds.contains(c.getBottom().getId())){
                double memoryWeight = calculateCurrentMemory(c.getBottom(), member);

                if (memoryWeight > criterion){ // 아직 기억에 남았다
                    res.getRememberedClothesList().add(ClothesDTO.of(c.getBottom(), memoryWeight));
                }else{
                    res.getForgottenClothesList().add(ClothesDTO.of(c.getBottom(), memoryWeight));
                }

                clothesIds.add(c.getBottom().getId());
            }
        }
        // 2-2. set에 없다면
        // 2-3. 가중치 계산
        // 2-4. 가중치가 일정 기준 (0.2) 이상이면 rememberList, 이하면 forgottenList
        // 3. 가중치가 0.2 이상이면 기억된 옷 이므로 리스트에 넣는다.

        return res;
    }

    private double calculateCurrentMemory(Clothes clothes, Member member){

        List<Coordinate> lastWornCoordinates = coordinateRepository.findLastWornCoordinates(clothes);

        if (lastWornCoordinates.isEmpty()
                || (lastWornCoordinates.size() == 1
                && lastWornCoordinates.get(0).getDate().isEqual(LocalDate.now()))) {
            return 0;
        }

        Coordinate lastWorn = (lastWornCoordinates.size() == 2
                && lastWornCoordinates.get(0).getDate().isEqual(LocalDate.now()))
                ? lastWornCoordinates.get(1) : lastWornCoordinates.get(0);

        Duration between = Duration.between(LocalDateTime.of(lastWorn.getDate(), member.getWorkEndTime()), LocalDateTime.now());
        long t = between.toHours();

        return calculateMemory(clothes, lastWorn, t);
    }

    private double calculateMemory(Clothes clothes, Coordinate lastWorn, long t) {

        List<Voice> voiceList = voiceRepository.findByDate(clothes.getMember().getId(), lastWorn.getDate());

        double res = 1;


        for (Voice voice : voiceList) {
            res *= 1 - calculateEachMemory(clothes, voice, t);
        }

        return 1 - res;
    }

    private double calculateEachMemory(Clothes clothes, Voice voice, long t) {
        return calculateInitialMemory(clothes, voice.getTime()) * Math.exp(-clothes.getWeight() * t);
    }

    private double calculateInitialMemory(Clothes clothes, int time) {
        return 1 - Math.exp(-0.005 / clothes.getWeight() * time);
    }

    private long calculateLeftTime(Clothes clothes, Member member) {

        List<Coordinate> lastWornCoordinates = coordinateRepository.findLastWornCoordinates(clothes);

        if (lastWornCoordinates.isEmpty()
                || (lastWornCoordinates.size() == 1
                && lastWornCoordinates.get(0).getDate().isEqual(LocalDate.now()))) {
            return 0;
        }

        Coordinate lastWorn = (lastWornCoordinates.size() == 2
                && lastWornCoordinates.get(0).getDate().isEqual(LocalDate.now()))
                ? lastWornCoordinates.get(1) : lastWornCoordinates.get(0);

        if (calculateMemory(clothes, lastWorn, 0) < criterion) return 0;

        int s = 0, e = 1000;

        while (e - s > 1) {
            int m = (s + e) >> 1;

            if (calculateMemory(clothes, lastWorn, m) >= criterion) s = m;
            else e = m;
        }

        return Math.max(0, e - Duration.between(LocalDateTime.of(lastWorn.getDate(), member.getWorkEndTime()), LocalDateTime.now()).toHours());
    }

    public ClothesCheckRes checkClothes(Long memberId, ClothesCheckReq clothesCheckReq) {

        Member member = memberRepository.findById(memberId).
                orElseThrow(()->new BusinessLogicException(ErrorCode.NOT_FOUND));

        ClothesCheckRes res = new ClothesCheckRes();

        // 1. 들어온 옷이 DB에 이미 존재하는지 확인
        clothesCheckReq.defaultSetting();
        Color enumColor = Color.valueOf(clothesCheckReq.getColor().toUpperCase());
        Type enumType = Type.valueOf(clothesCheckReq.getType().toUpperCase());
        Category enumCategory = Category.valueOf(clothesCheckReq.getCategory().toUpperCase());
        Pattern enumPattern = Pattern.valueOf(clothesCheckReq.getPattern().toUpperCase());

        Optional<Clothes> existingClothes = clothesRepository.findClothes(
                memberId,
                clothesCheckReq.getIsTop(),
                enumColor,
                enumType,
                enumCategory,
                enumPattern
        );

        res.setIsTop(clothesCheckReq.getIsTop());
        // 1-1. DB에 없다 -> true, add 후 clothesId 반환
        if (existingClothes.isEmpty()){
            res.setIsAvailable(true);
            res.setClothesId(addClothes(clothesCheckReq.of(), memberId).getClothesId());
        }
        // 1-2. DB에 있다 -> 기억도 가중치 계산, DTO에 옷 정보 넣기
        else {
            double memoryWeight = calculateCurrentMemory(existingClothes.get(), member);
            res.setClothesId(existingClothes.get().getId());

            // 1-2-1. 가중치가 0.2 초과 -> false
            if (memoryWeight > criterion){
                res.setIsAvailable(false);
            }
            // 1-2-2. 가중치가 0.2 이하 -> true
            else {
                res.setIsAvailable(true);
            }
        }
        return res;
    }

    public ClothesPredictionListRes predictCoordinate(Long memberId) {

        Member member = memberRepository.findById(memberId).
                orElseThrow(()->new BusinessLogicException(ErrorCode.NOT_FOUND));

        ClothesPredictionListRes res = new ClothesPredictionListRes();
        // 1. 45일간의 코디 조회
        LocalDate before45 = LocalDate.now().minusDays(45);
        List<Coordinate> coordinates = coordinateRepository.findCoordinatesLast45(memberId, before45);

        // 2. (상의, 하의)로 조합의 입은 횟수 count
        Map<String, Integer> coordinateCountMap = new HashMap<>();
        for (Coordinate c: coordinates){
            // 만약 상의가 기억에 남지 않았다면
            if (calculateCurrentMemory(c.getTop(), member)<=criterion){
                // 2-1. 상의-하의 조합으로 키(String) 만들기
                String coordinateKey = c.getTop().getId() + " " + c.getBottom().getId();
                // 2-2-1. 만약 이 키가 맵에 존재 -> 해당 키의 값 1 증가
                if (coordinateCountMap.containsKey(coordinateKey)){
                    coordinateCountMap.put(coordinateKey, coordinateCountMap.get(coordinateKey) + 1);
                }
                // 2-2-2. 만약 이 키가 맵에 존재X -> (키, 1) 추가
                else{
                    coordinateCountMap.put(coordinateKey, 1);
                }
            }
        }
        // 3. 주기 계산 : 45/입은 횟수
        Map<String, Integer> cycleMap = new HashMap<>();
        for (String key: coordinateCountMap.keySet()){
            cycleMap.put(key, 45/coordinateCountMap.get(key));
        }

        // 4. 마지막 입은 날 + 주기 가 오늘 아후 이고, 오늘로부터 가까운 상위 6개
        Map<String, LocalDate> predictMap = new HashMap<>();
        for (String key: cycleMap.keySet()){
            // 4-1. 해당 키에 대한 lastworn 찾기
            String[] keys = key.split(" ");
            Long topId = Long.parseLong(keys[0]);
            Long bottomId = Long.parseLong(keys[1]);
            LocalDate lastworn = coordinateRepository.findLastwornByTopAndBottom(memberId, topId, bottomId);

            // 4-2. 마지막 입은 날 + 주기 저장
            LocalDate predictedDate = lastworn.plusDays(cycleMap.get(key));
            predictMap.put(key, predictedDate);
        }
        // 5. 날짜 느린순으로 정렬
        List<Map.Entry<String, LocalDate>> sortedPredictList = new ArrayList<>(predictMap.entrySet());
        sortedPredictList.sort(Map.Entry.comparingByValue());

        // 6. 오늘 이후의 날짜 중 가장 앞 6개
        LocalDate today = LocalDate.now();

        List<ClothesPredictionDto> predictionDtoList = new ArrayList<>();

        for (Map.Entry<String, LocalDate> entry : sortedPredictList){
            // 오늘이랑 같거나 이후라면 res의 list에 추가
            if (entry.getValue().compareTo(today)>=0){

                String[] keys = entry.getKey().split(" ");
                Long topId = Long.parseLong(keys[0]);
                Long bottomId = Long.parseLong(keys[1]);

                Clothes top = clothesRepository.findById(topId)
                        .orElseThrow(() -> new BusinessLogicException(ErrorCode.NOT_FOUND));
                Clothes bottom = clothesRepository.findById(bottomId)
                        .orElseThrow(() -> new BusinessLogicException(ErrorCode.NOT_FOUND));

                ClothesDTO topDTO = ClothesDTO.of(top);
                ClothesDTO bottomDTO = ClothesDTO.of(bottom);

                predictionDtoList.add(new ClothesPredictionDto(topDTO, bottomDTO));
            }

            if (predictionDtoList.size()==6)
                break;
        }

        // 만약 6개가 안 차면
        if (predictionDtoList.size()<6){
            // 날짜 빠른순으로 reverse
            Collections.reverse(sortedPredictList);

            for (Map.Entry<String, LocalDate> entry : sortedPredictList){
                // 오늘이랑 같거나 이후라면 res의 list에 추가
                if (entry.getValue().compareTo(today)<0){

                    String[] keys = entry.getKey().split(" ");
                    Long topId = Long.parseLong(keys[0]);
                    Long bottomId = Long.parseLong(keys[1]);

                    Clothes top = clothesRepository.findById(topId)
                            .orElseThrow(() -> new BusinessLogicException(ErrorCode.NOT_FOUND));
                    Clothes bottom = clothesRepository.findById(bottomId)
                            .orElseThrow(() -> new BusinessLogicException(ErrorCode.NOT_FOUND));

                    ClothesDTO topDTO = ClothesDTO.of(top);
                    ClothesDTO bottomDTO = ClothesDTO.of(bottom);

                    predictionDtoList.add(new ClothesPredictionDto(topDTO, bottomDTO));
                }

                if (predictionDtoList.size()==6)
                    break;
            }
        }

        res.setPredictionList(predictionDtoList);

        return res;
    }
}
