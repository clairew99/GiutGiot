package com.gugucon.kiot.domain.coordinate.dto;
import lombok.Data;

import java.time.LocalDate;

@Data
public class CoordinateModifyReq {

    private LocalDate date;

    private Long topId;

    private Long bottomId;

}