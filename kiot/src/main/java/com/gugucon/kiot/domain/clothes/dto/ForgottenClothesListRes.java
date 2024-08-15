package com.gugucon.kiot.domain.clothes.dto;

import lombok.Data;

import java.util.List;

@Data
public class ForgottenClothesListRes {

    private List<ClothesDTO> clothesList;
}