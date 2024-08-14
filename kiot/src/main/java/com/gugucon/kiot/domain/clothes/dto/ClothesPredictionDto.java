package com.gugucon.kiot.domain.clothes.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@AllArgsConstructor
public class ClothesPredictionDto {

    private ClothesDTO top;

    private ClothesDTO bottom;
}
