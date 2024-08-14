package com.gugucon.kiot.domain.member.dto;

import com.gugucon.kiot.domain.member.entity.Member;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class MemberFindRes {

    private String nickname;

    private Integer workStartTime;

    private Integer workEndTime;

    public static MemberFindRes of(Member member) {

        return MemberFindRes.builder()
                .nickname(member.getNickname())
                .workStartTime(member.getWorkStartTime().getHour())
                .workEndTime(member.getWorkEndTime().getHour())
                .build();
    }
}
