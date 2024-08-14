package com.gugucon.kiot.domain.clothes.dto;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class ClothesMemoryListRes {

    private List<ClothesDTO> rememberedClothesList = new ArrayList<>();

    private List<ClothesDTO> forgottenClothesList = new ArrayList<>();
}