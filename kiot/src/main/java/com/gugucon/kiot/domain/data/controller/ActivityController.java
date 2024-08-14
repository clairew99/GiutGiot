package com.gugucon.kiot.domain.data.controller;

import com.gugucon.kiot.domain.data.dto.ActivityAddReq;
import com.gugucon.kiot.domain.data.service.ActivityService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/activity")
@RequiredArgsConstructor
public class ActivityController {

    private final ActivityService activityService;

    @PostMapping
    public ResponseEntity<?> ActivityDataSave(@RequestBody ActivityAddReq request){
        Long memberId = 1L;
        activityService.saveActivity(request, memberId);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }
}
