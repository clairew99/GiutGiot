package com.gugucon.kiot.domain.clothes.controller;

import com.gugucon.kiot.domain.clothes.dto.*;
import com.gugucon.kiot.domain.clothes.enums.Category;
import com.gugucon.kiot.domain.clothes.enums.Color;
import com.gugucon.kiot.domain.clothes.enums.Pattern;
import com.gugucon.kiot.domain.clothes.enums.Type;
import com.gugucon.kiot.domain.clothes.service.ClothesService;
import com.gugucon.kiot.global.argumentresolver.LoginId;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

import static org.springframework.http.HttpStatus.*;

@RestController
@RequestMapping("/clothes")
@RequiredArgsConstructor
public class ClothesController {

    private final ClothesService clothesService;

    @PostMapping
    public ResponseEntity<ClothesAddRes> clothesAdd(
            @LoginId Long memberId,
            @RequestBody ClothesAddReq clothesAddReq) {

        clothesAddReq.defaultSetting();
        ClothesAddRes response = clothesService.addClothes(clothesAddReq, memberId);

        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }

    @GetMapping("/{clothesId}")
    public ResponseEntity<ClothesDetailsRes> clothesDetails(
            @LoginId Long memberId,
            @PathVariable Long clothesId) {

        ClothesDetailsRes response = clothesService.findClothes(memberId, clothesId);

        return new ResponseEntity<>(response, OK);
    }

    @GetMapping("/prediction")
    public ResponseEntity<ClothesPredictionListRes> clothesPredictionList(@LoginId Long memberId) {

        ClothesPredictionListRes response = clothesService.predictCoordinate(memberId);

        return new ResponseEntity<>(response, OK);
    }

    @GetMapping("/memory")
    public ResponseEntity<ClothesMemoryListRes> clothesMemoryList(@LoginId Long memberId) {

        ClothesMemoryListRes response = clothesService.findClothesMemory(memberId);

        return new ResponseEntity<>(response, OK);
    }

    @PostMapping("/check")
    public ResponseEntity<ClothesCheckRes> checkClothesAvailability(
            @LoginId Long memberId,
            @RequestBody ClothesCheckReq clothesCheckReq){

        ClothesCheckRes response = clothesService.checkClothes(memberId, clothesCheckReq);

        return new ResponseEntity<>(response, OK);
    }
}
