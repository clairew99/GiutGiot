package com.gugucon.kiot.domain.data.entity;

import com.gugucon.kiot.domain.coordinate.entity.Coordinate;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class Activity {

    @EmbeddedId
    private ActivityId id;

    private Integer time;

    public void addTime(Integer time) {
        this.time += time;
    }

}
