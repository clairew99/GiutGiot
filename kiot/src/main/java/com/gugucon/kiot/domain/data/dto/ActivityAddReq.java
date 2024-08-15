package com.gugucon.kiot.domain.data.dto;

import lombok.Data;

import java.sql.Time;
import java.time.LocalDate;

@Data
public class ActivityAddReq {

    private Integer time;
    private LocalDate date;
}
