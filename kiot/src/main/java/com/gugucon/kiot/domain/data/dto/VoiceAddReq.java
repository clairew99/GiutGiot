package com.gugucon.kiot.domain.data.dto;

import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class VoiceAddReq {
    private List<Integer> voiceList;
    private LocalDate date;
}
