package com.gugucon.kiot.domain.clothes.dto;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class ClothesPredictionListRes {

    private List<ClothesPredictionDto> predictionList;
}
