package com.gugucon.kiot.domain.member.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalTime;

@Entity
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Member {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "member_id")
    private Long id;

    private String nickname;

    private String email;

    private LocalTime workStartTime;

    private LocalTime workEndTime;

    public void updateNickname(String newNickname) {
        this.nickname = newNickname;
    }

    public void updateWorkStartTime(Integer startTime) {
        this.workStartTime = LocalTime.of(startTime, 0);
    }

    public void updateWorkEndTime(Integer endTime) {
        this.workEndTime = LocalTime.of(endTime, 0);
    }
}
