package com.gugucon.kiot.domain.clothes.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Data
@NoArgsConstructor
public class ClothesCheckRes {

    private Boolean isAvailable;

    private Boolean isTop;

    private Long clothesId;

}
