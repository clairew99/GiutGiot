package com.gugucon.kiot.domain.coordinate.controller;

import com.gugucon.kiot.domain.coordinate.dto.*;
import com.gugucon.kiot.domain.coordinate.service.CoordinateService;
import com.gugucon.kiot.global.argumentresolver.LoginId;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/coordinates")
public class CoordinateController {

    private final CoordinateService coordinateService;

    public CoordinateController(CoordinateService coordinateService) {
        this.coordinateService = coordinateService;
    }

    @PostMapping
    public ResponseEntity<?> coordinateAdd(
            @LoginId Long memberId,
            @RequestBody CoordinateAddReq coordinateAddReq) {

        coordinateService.addCoordinate(coordinateAddReq, memberId);
        return new ResponseEntity<>(null, HttpStatus.CREATED);
    }

    @GetMapping
    public ResponseEntity<CoordinateListRes> coordinateList(
            @LoginId Long memberId,
            @RequestParam Integer year,
            @RequestParam Integer month,
            @RequestParam Integer day
    ) {

        CoordinateListRes response = coordinateService.findTwoWeeksCoordinates(memberId, year, month, day);

        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @GetMapping("/daily")
    public ResponseEntity<CoordinateDetailRes> coordinateDetail(
            @LoginId Long memberId,
            @RequestParam Integer year,
            @RequestParam Integer month,
            @RequestParam Integer day
    ) {

        CoordinateDetailRes response = coordinateService.getCoordinateDetail(memberId, year, month, day);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PatchMapping
    public ResponseEntity<CoordinateModifyRes> coordinateModify(
            @LoginId Long memberId,
            @RequestBody CoordinateModifyReq request) {

        CoordinateModifyRes response = coordinateService.modifyCoordinate(memberId, request);

        return new ResponseEntity<>(response, HttpStatus.OK);
    }



}