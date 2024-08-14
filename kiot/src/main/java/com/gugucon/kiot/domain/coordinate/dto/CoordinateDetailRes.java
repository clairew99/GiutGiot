package com.gugucon.kiot.domain.coordinate.dto;

import com.gugucon.kiot.domain.clothes.enums.Category;
import com.gugucon.kiot.domain.clothes.enums.Color;
import com.gugucon.kiot.domain.clothes.enums.Pattern;
import com.gugucon.kiot.domain.clothes.enums.Type;
import com.gugucon.kiot.domain.coordinate.entity.Coordinate;
import com.gugucon.kiot.domain.coordinate.enums.Pose;
import lombok.Data;

@Data
public class CoordinateDetailRes {

    private Long topId;

    private Color topColor;

    private Category topCategory;

    private Type topType;

    private Pattern topPattern;

    private Long bottomId;

    private Color bottomColor;

    private Category bottomCategory;

    private Type bottomType;

    private Pattern bottomPattern;

    private Pose pose;

    public CoordinateDetailRes(Coordinate coordinate) {
        this.topId = coordinate.getTop().getId();
        this.topColor = coordinate.getTop().getColor();
        this.topCategory = coordinate.getTop().getCategory();
        this.topType = coordinate.getTop().getType();
        this.topPattern = coordinate.getTop().getPattern();

        this.bottomId = coordinate.getBottom().getId();
        this.bottomColor = coordinate.getBottom().getColor();
        this.bottomCategory = coordinate.getBottom().getCategory();
        this.bottomType = coordinate.getBottom().getType();
        this.bottomPattern = coordinate.getBottom().getPattern();

        this.pose = coordinate.getPose();
    }
}