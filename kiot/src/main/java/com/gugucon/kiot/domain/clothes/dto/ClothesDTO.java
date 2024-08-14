package com.gugucon.kiot.domain.clothes.dto;

import com.gugucon.kiot.domain.clothes.entity.Clothes;
import com.gugucon.kiot.domain.clothes.enums.Category;
import com.gugucon.kiot.domain.clothes.enums.Color;
import com.gugucon.kiot.domain.clothes.enums.Pattern;
import com.gugucon.kiot.domain.clothes.enums.Type;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ClothesDTO {

    private Long clothesId;

    private Boolean isTop;

    private Color color;

    private Category category;

    private Type type;

    private Pattern pattern;

    private Double memory;

    public static ClothesDTO of(Clothes clothes, double memory){
        return ClothesDTO.builder()
                .clothesId(clothes.getId())
                .isTop(clothes.getIsTop())
                .color(clothes.getColor())
                .category(clothes.getCategory())
                .type(clothes.getType())
                .pattern(clothes.getPattern())
                .memory(memory)
                .build();
    }

    public static ClothesDTO of(Clothes clothes){
        return ClothesDTO.builder()
                .clothesId(clothes.getId())
                .isTop(clothes.getIsTop())
                .color(clothes.getColor())
                .category(clothes.getCategory())
                .type(clothes.getType())
                .pattern(clothes.getPattern())
                .build();
    }

    public static ClothesDTO of(ClothesCheckReq req){
        return ClothesDTO.builder()
                .isTop(req.getIsTop())
                .color(Color.valueOf(req.getColor()))
                .category(Category.valueOf(req.getCategory()))
                .type(Type.valueOf(req.getType()))
                .pattern(Pattern.valueOf(req.getPattern()))
                .build();
    }
}
