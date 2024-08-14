package com.gugucon.kiot.domain.member.service;

import com.gugucon.kiot.domain.clothes.repository.ClothesRepository;
import com.gugucon.kiot.domain.coordinate.repository.CoordinateRepository;
import com.gugucon.kiot.domain.data.repository.ActivityRepository;
import com.gugucon.kiot.domain.data.repository.VoiceRepository;
import com.gugucon.kiot.domain.member.dto.LoginReq;
import com.gugucon.kiot.domain.member.dto.LoginRes;
import com.gugucon.kiot.domain.member.dto.MemberFindRes;
import com.gugucon.kiot.domain.member.dto.MemberModifyReq;
import com.gugucon.kiot.domain.member.entity.Member;
import com.gugucon.kiot.domain.member.repository.MemberRepository;
import com.gugucon.kiot.global.exception.BusinessLogicException;
import com.gugucon.kiot.global.oauth.MemberDTO;
import com.gugucon.kiot.global.redis.RedisUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

import static com.gugucon.kiot.global.exception.ErrorCode.LOGIN_FAILED;
import static com.gugucon.kiot.global.exception.ErrorCode.NOT_FOUND;

@Service
@RequiredArgsConstructor
@Transactional
public class MemberService {

    private final MemberRepository memberRepository;
    private final ClothesRepository clothesRepository;
    private final CoordinateRepository coordinateRepository;
    private final VoiceRepository voiceRepository;
    private final ActivityRepository activityRepository;
    private final RedisUtils redisUtils;

    @Transactional(readOnly = true)
    public MemberFindRes findMember(Long memberId) {

        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new BusinessLogicException(NOT_FOUND));

        return MemberFindRes.of(member);
    }

    public void modifyMember(Long memberId, MemberModifyReq memberModifyReq) {

        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new BusinessLogicException(NOT_FOUND));

        Optional.ofNullable(memberModifyReq.getNickname()).ifPresent(member::updateNickname);
        Optional.ofNullable(memberModifyReq.getWorkStartTime()).ifPresent(member::updateWorkStartTime);
        Optional.ofNullable(memberModifyReq.getWorkEndTime()).ifPresent(member::updateWorkEndTime);

        memberRepository.save(member);
    }

    public void removeMember(Long memberId) {

        voiceRepository.deleteAllByIdMemberId(memberId);
        activityRepository.deleteAllByIdMemberId(memberId);
        coordinateRepository.deleteAllByIdMemberId(memberId);
        clothesRepository.deleteAllByMemberId(memberId);
        memberRepository.deleteById(memberId);
    }

    @Transactional(readOnly = true)
    public LoginRes login(LoginReq loginReq) {

        MemberDTO data = (MemberDTO) redisUtils.getData(loginReq.getCode());

        if (data == null) {
            throw new BusinessLogicException(LOGIN_FAILED);
        }

        return new LoginRes(data);
    }
}
