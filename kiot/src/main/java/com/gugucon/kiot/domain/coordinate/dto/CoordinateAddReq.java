package com.gugucon.kiot.domain.coordinate.dto;

import com.gugucon.kiot.domain.clothes.entity.Clothes;
import com.gugucon.kiot.domain.coordinate.entity.Coordinate;
import com.gugucon.kiot.domain.coordinate.entity.CoordinateId;
import com.gugucon.kiot.domain.coordinate.enums.Pose;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CoordinateAddReq {

    private Long topId;

    private Long bottomId;

    private LocalDate date;

    public Coordinate toCoordinate(Long memberId, Clothes top, Clothes bottom){
        return new Coordinate(new CoordinateId(memberId, date), top, bottom, Pose.SITTING);
    };
}