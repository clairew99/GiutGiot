package com.gugucon.kiot.domain.coordinate.entity;

import com.gugucon.kiot.domain.clothes.entity.Clothes;
import com.gugucon.kiot.domain.coordinate.enums.Pose;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class Coordinate {

    @EmbeddedId
    private CoordinateId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "top_id")
    private Clothes top;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "bottom_id")
    private Clothes bottom;

    @Enumerated(EnumType.STRING)
    private Pose pose;

    public void updateTop(Clothes top) {
        this.top = top;
    }

    public void updateBottom(Clothes bottom) {
        this.bottom = bottom;
    }

    public void updatePose(Pose pose) {
        this.pose = pose;
    }

    public void updateDate(LocalDate date) {
        this.id.setDate(date);
    }

    public void updateMember(Long memberId) {
        this.id.setMemberId(memberId);
    }

    public void setCoordinateId(Long memberId, LocalDate date) {
        this.id = new CoordinateId(memberId, date);
    }

    public Long getMemberId() {
        return id.getMemberId();
    }

    public LocalDate getDate() {
        return id.getDate();
    }
}
