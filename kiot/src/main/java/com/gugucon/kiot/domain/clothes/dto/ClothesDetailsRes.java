package com.gugucon.kiot.domain.clothes.dto;

import com.gugucon.kiot.domain.clothes.entity.Clothes;
import com.gugucon.kiot.domain.clothes.enums.Category;
import com.gugucon.kiot.domain.clothes.enums.Color;
import com.gugucon.kiot.domain.clothes.enums.Pattern;
import com.gugucon.kiot.domain.clothes.enums.Type;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;

@Data
@Builder
@AllArgsConstructor
public class ClothesDetailsRes {

    private Long clothesId;

    private Boolean isTop;

    private Color color;

    private Category category;

    private Type type;

    private Pattern pattern;

    private LocalDate lastWorn;

    private Integer conversationCount;

    private Integer conversationTime;

    private Integer walkingTime;

    private Double memory;

    private Long leftTime;

    public static ClothesDetailsRes of(Clothes clothes, LocalDate lastworn, int conversationCount, int conversationTime, int walkingTime, double memory, long leftTime){
        return ClothesDetailsRes.builder()
                .clothesId(clothes.getId())
                .isTop(clothes.getIsTop())
                .color(clothes.getColor())
                .category(clothes.getCategory())
                .type(clothes.getType())
                .pattern(clothes.getPattern())
                .lastWorn(lastworn)
                .conversationCount(conversationCount)
                .conversationTime(conversationTime)
                .walkingTime(walkingTime)
                .memory(memory)
                .leftTime(leftTime)
                .build();
    }
}
