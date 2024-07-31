package com.gugucon.kiot.domain.coordinate.entity;

import com.gugucon.kiot.domain.clothes.entity.Clothes;
import com.gugucon.kiot.domain.coordinate.enums.Pose;
import jakarta.persistence.*;
import lombok.Getter;

import java.time.LocalDate;

@Entity
@Getter
public class Coordinate {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "coordinate_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "top_id")
    private Clothes top;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "bottom_id")
    private Clothes bottom;

    private Boolean isTop;

    private LocalDate date;

    @Enumerated(EnumType.STRING)
    private Pose pose;
}
