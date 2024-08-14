package com.gugucon.kiot.domain.member.dto;

import com.gugucon.kiot.global.oauth.MemberDTO;
import lombok.Data;

@Data
public class LoginRes {

    private Long memberId;

    private String nickname;

    private Integer workStartTime;

    private Integer workEndTime;

    public LoginRes(MemberDTO memberDTO) {
        this.memberId = memberDTO.getId();
        this.nickname = memberDTO.getNickname();
        this.workStartTime = memberDTO.getWorkStartTime();
        this.workEndTime = memberDTO.getWorkEndTime();
    }
}
