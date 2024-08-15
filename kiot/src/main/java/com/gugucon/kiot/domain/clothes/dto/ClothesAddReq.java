
package com.gugucon.kiot.domain.clothes.dto;

import com.gugucon.kiot.domain.clothes.entity.Clothes;
import com.gugucon.kiot.domain.clothes.enums.Category;
import com.gugucon.kiot.domain.clothes.enums.Color;
import com.gugucon.kiot.domain.clothes.enums.Pattern;
import com.gugucon.kiot.domain.clothes.enums.Type;
import com.gugucon.kiot.domain.member.entity.Member;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ClothesAddReq {

    @NotNull
    private Boolean isTop;

    @NotNull
    private String color;

    private String type;

    private String category;

    private String pattern;

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

    public Clothes toClothes(Member member, Boolean isTop, Color enumColor, Type enumType, Category enumCategory, Pattern enumPattern) {

        return Clothes.builder()
                .member(member)
                .isTop(isTop)
                .color(enumColor)
                .type(enumType)
                .category(enumCategory)
                .pattern(enumPattern)
                .build();
    }

    public void defaultSetting() {
        if (type == null) type = defaultTypeBySeason();
        if (category == null) category = defaultCategoryByIsTop(isTop);
        if (pattern == null) pattern = "SOLID";
    }
}
