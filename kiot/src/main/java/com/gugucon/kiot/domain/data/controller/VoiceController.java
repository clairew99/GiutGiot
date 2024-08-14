package com.gugucon.kiot.domain.data.controller;

import com.gugucon.kiot.domain.data.dto.VoiceAddReq;
import com.gugucon.kiot.domain.data.service.VoiceService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/voice")
@RequiredArgsConstructor
public class VoiceController {

    private final VoiceService voiceService;

    @PostMapping
    public ResponseEntity<?> VoiceDataSave(@RequestBody VoiceAddReq request) {
        Long memberId = 1L;
        voiceService.saveVoiceData(request, memberId);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }
}
