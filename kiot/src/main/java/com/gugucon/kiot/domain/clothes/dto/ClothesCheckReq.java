package com.gugucon.kiot.domain.clothes.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;

@Data
public class ClothesCheckReq {

    @NotNull
    private Boolean isTop;

    @NotNull
    private String color;

    private String type;

    private String category;

    private String pattern;

    public ClothesAddReq of(){
        return new ClothesAddReq(isTop, color, type, category, pattern);
    }

    private String defaultTypeBySeason(){
        int month = LocalDate.now().getMonthValue();

        if (month>=6 && month<=9){
            return "SHORT";
        }
        return "LONG";
    }

    private String defaultCategoryByIsTop(Boolean isTop){
        if (isTop)
            return "COTTON";
        return "JEANS";
    }

    public void defaultSetting() {
        if (type == null) type = defaultTypeBySeason();
        if (category == null) category = defaultCategoryByIsTop(isTop);
        if (pattern == null) pattern = "SOLID";
    }

}
