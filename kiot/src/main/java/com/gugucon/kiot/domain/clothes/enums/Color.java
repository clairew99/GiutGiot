package com.gugucon.kiot.domain.clothes.enums;

import lombok.Getter;

@Getter
public enum Color {
    BLACK(0.6058, 0, 0),
    WHITE(0.6058, 0, 1),
    GRAY(0.6058, 0.5, 0.5),
    IVORY(0.57, 0.06, 1),
    BROWN(0.6058, 0.75, 0.65),
    NAVY(0.5625, 1, 0.5),
    BLUE(0.5625, 1, 1),
    SKYBLUE(0.5524, 0.43, 0.92),
    GREEN(0.5342, 1, 0.5),
    PINK(0.6022, 0.25, 1),
    RED(0.6058, 1, 1),
    YELLOW(0.57, 1, 1),
    ORANGE(0.5825, 1, 1),
    PURPLE(0.5842, 1, 0.5),
    LAVENDER(0.5625, 0.08, 0.98);

    private final double hue;
    private final double saturation;
    private final double brightness;

    Color(double hue, double saturation, double brightness) {
        this.hue = hue;
        this.saturation = saturation;
        this.brightness = brightness;

    }
}
