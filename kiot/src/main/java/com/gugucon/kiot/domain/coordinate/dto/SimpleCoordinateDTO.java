package com.gugucon.kiot.domain.coordinate.dto;

import com.gugucon.kiot.domain.clothes.enums.Color;
import com.gugucon.kiot.domain.coordinate.entity.Coordinate;
import com.gugucon.kiot.domain.coordinate.enums.Pose;
import lombok.Data;

import java.time.LocalDate;

@Data
public class SimpleCoordinateDTO {

    private Color topColor;

    private Color bottomColor;

    private LocalDate date;

    private Pose pose;

    public SimpleCoordinateDTO(Coordinate coordinate) {
        this.topColor = coordinate.getTop().getColor();
        this.bottomColor = coordinate.getBottom().getColor();
        this.date = coordinate.getDate();
        this.pose = coordinate.getPose();
    }
}