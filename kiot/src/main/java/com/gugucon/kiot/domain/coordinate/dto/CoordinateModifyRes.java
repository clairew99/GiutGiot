package com.gugucon.kiot.domain.coordinate.dto;

import com.gugucon.kiot.domain.clothes.enums.Category;
import com.gugucon.kiot.domain.clothes.enums.Color;
import com.gugucon.kiot.domain.clothes.enums.Pattern;
import com.gugucon.kiot.domain.clothes.enums.Type;
import com.gugucon.kiot.domain.coordinate.entity.Coordinate;
import lombok.Data;

@Data
public class CoordinateModifyRes {

    private Color topColor;
    private Category topCategory;
    private Type topType;
    private Pattern topPattern;

    private Color bottomColor;
    private Category bottomCategory;
    private Type bottomType;
    private Pattern bottomPattern;

    public CoordinateModifyRes(Coordinate coordinate) {
        this.topColor = coordinate.getTop().getColor();
        this.topCategory = coordinate.getTop().getCategory();
        this.topType = coordinate.getTop().getType();
        this.topPattern = coordinate.getTop().getPattern();

        this.bottomColor = coordinate.getBottom().getColor();
        this.bottomCategory = coordinate.getBottom().getCategory();
        this.bottomType = coordinate.getBottom().getType();
        this.bottomPattern = coordinate.getBottom().getPattern();
    }
}
