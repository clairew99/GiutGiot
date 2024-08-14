package com.gugucon.kiot.domain.coordinate.service;

import com.gugucon.kiot.domain.clothes.entity.Clothes;
import com.gugucon.kiot.domain.clothes.repository.ClothesRepository;
import com.gugucon.kiot.domain.coordinate.dto.*;
import com.gugucon.kiot.domain.coordinate.entity.Coordinate;
import com.gugucon.kiot.domain.coordinate.entity.CoordinateId;
import com.gugucon.kiot.domain.coordinate.enums.Pose;
import com.gugucon.kiot.domain.coordinate.repository.CoordinateRepository;
import com.gugucon.kiot.global.exception.BusinessLogicException;
import com.gugucon.kiot.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CoordinateServiceImpl implements CoordinateService {

    private final CoordinateRepository coordinateRepository;
    private final ClothesRepository clothesRepository;

    @Override
    public void addCoordinate(CoordinateAddReq req, Long memberId) {
        Clothes top = clothesRepository.findById(req.getTopId())
                .orElseThrow(() -> new BusinessLogicException(ErrorCode.NOT_FOUND));
        Clothes bottom = clothesRepository.findById(req.getBottomId())
                .orElseThrow(() -> new BusinessLogicException(ErrorCode.NOT_FOUND));
        if(!top.getMember().getId().equals(memberId)) {
            throw new BusinessLogicException(ErrorCode.NOT_MEMBER_CLOTHES);
        }
        if(!bottom.getMember().getId().equals(memberId)) {
            throw new BusinessLogicException(ErrorCode.NOT_MEMBER_CLOTHES);
        }
        if(!top.getIsTop() || bottom.getIsTop()) {
            throw new BusinessLogicException(ErrorCode.NOT_MATCH_TOP);
        }

        Coordinate coordinate = req.toCoordinate(memberId, top, bottom);
        coordinateRepository.save(coordinate);
    }

    @Override
    public CoordinateListRes findTwoWeeksCoordinates(Long memberId, Integer year, Integer month, Integer day) {
        LocalDate startDate = LocalDate.of(year, month, day).minusDays(13).with(DayOfWeek.SUNDAY);
        LocalDate endDate = startDate.plusDays(13);

        List<Coordinate> coordinates = coordinateRepository.findByIdMemberIdAndIdDateBetween(memberId, startDate, endDate);

        List<SimpleCoordinateDTO> simpleCoordinateDTOS = coordinates.stream()
                .map(SimpleCoordinateDTO::new)
                .toList();
        return new CoordinateListRes(simpleCoordinateDTOS, startDate, endDate);
    }

    @Override
    public CoordinateDetailRes getCoordinateDetail(Long memberId, Integer year, Integer month, Integer day) {

        LocalDate date = LocalDate.of(year, month, day);
        Coordinate coordinate = coordinateRepository.findByIdMemberIdAndIdDate(memberId, date)
                .orElseThrow(() -> new BusinessLogicException(ErrorCode.NOT_FOUND));

        return new CoordinateDetailRes(coordinate);
    }

    @Override
    public CoordinateModifyRes modifyCoordinate(Long memberId, CoordinateModifyReq request) {

        LocalDate date = request.getDate();
        Coordinate coordinate = coordinateRepository.findById(new CoordinateId(memberId, date))
                .orElseThrow(() -> new BusinessLogicException(ErrorCode.NOT_FOUND));

        if(request.getTopId() != null) {
            Clothes top = clothesRepository.findByIdWithMember(request.getTopId())
                            .orElseThrow(() -> new BusinessLogicException(ErrorCode.NOT_FOUND));
            if(!top.getMember().getId().equals(memberId)) {
                throw new BusinessLogicException(ErrorCode.NOT_MEMBER_CLOTHES);
            }
            if(!top.getIsTop()) {
                throw new BusinessLogicException(ErrorCode.NOT_MATCH_TOP);
            }

            coordinate.updateTop(top);
        }

        if(request.getBottomId() != null) {
            Clothes bottom = clothesRepository.findByIdWithMember(request.getBottomId())
                        .orElseThrow(() -> new BusinessLogicException(ErrorCode.NOT_FOUND));
            if(!bottom.getMember().getId().equals(memberId)) {
                throw new BusinessLogicException(ErrorCode.NOT_MEMBER_CLOTHES);
            }
            if(bottom.getIsTop()) {
                throw new BusinessLogicException(ErrorCode.NOT_MATCH_TOP);
            }

            coordinate.updateBottom(bottom);
        }

        coordinateRepository.save(coordinate);
        return new CoordinateModifyRes(coordinate);
    }
}