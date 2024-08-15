package com.gugucon.kiot.domain.member.dto;

import lombok.Data;

@Data
public class MemberModifyReq {

    private String nickname;

    private Integer workStartTime;

    private Integer workEndTime;
}
