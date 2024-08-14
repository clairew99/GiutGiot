package com.gugucon.kiot.domain.coordinate.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
@AllArgsConstructor
public class CoordinateListRes {

    private List<SimpleCoordinateDTO> coordinates;
    private LocalDate startOfWeek;
    private LocalDate endOfTwoWeeks;

}
