package com.gugucon.kiot.domain.clothes.dto;

import lombok.Data;

@Data
public class ClothesListReq {

    private Boolean isTop;

    private String color;

    private String type;

    private String pattern;
}
