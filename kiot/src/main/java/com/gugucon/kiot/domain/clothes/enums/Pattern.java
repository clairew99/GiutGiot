package com.gugucon.kiot.domain.clothes.enums;

import lombok.Getter;

@Getter
public enum Pattern {
    SOLID(1),
    PRINTING(1.3),
    STRIPE(1.1),
    DOT(1.5),
    CHECK(1.2),
    FLOWER(2);

    private final double weight;

    Pattern(double weight) {
        this.weight = weight;
    }
}
