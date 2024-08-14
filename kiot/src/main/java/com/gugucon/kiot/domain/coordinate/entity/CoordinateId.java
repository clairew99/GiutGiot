package com.gugucon.kiot.domain.coordinate.entity;

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
public class CoordinateId implements Serializable {

    private Long memberId;

    private LocalDate date;
}
