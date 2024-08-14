package com.gugucon.kiot.global.oauth;

import com.gugucon.kiot.domain.member.entity.Member;
import com.gugucon.kiot.global.oauth.response.OAuth2Response;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class MemberDTO {

    private Long id;

    private String nickname;

    private String email;

    private Integer workStartTime;

    private Integer workEndTime;

    public MemberDTO(OAuth2Response oAuth2Response) {
        this.nickname = oAuth2Response.getNickname();
        this.email = oAuth2Response.getEmail();
        this.workStartTime = 9;
        this.workEndTime = 18;
    }

    public static MemberDTO of(Member member) {

        return MemberDTO.builder()
                .id(member.getId())
                .nickname(member.getNickname())
                .email(member.getEmail())
                .workStartTime(member.getWorkStartTime().getHour())
                .workEndTime(member.getWorkEndTime().getHour())
                .build();
    }

    public Member toEntity() {

        return Member.builder()
                .nickname(nickname)
                .email(email)
                .workStartTime(LocalTime.of(workStartTime, 0))
                .workEndTime(LocalTime.of(workEndTime, 0))
                .build();
    }
}
