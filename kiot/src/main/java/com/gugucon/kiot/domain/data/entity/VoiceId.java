package com.gugucon.kiot.domain.data.entity;

import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDate;

@Embeddable
@Data
@NoArgsConstructor
@AllArgsConstructor
public class VoiceId implements Serializable {

    private Integer seq;

    private LocalDate date;

    private Long memberId;


}
