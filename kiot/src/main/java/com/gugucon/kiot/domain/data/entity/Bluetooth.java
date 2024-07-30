package com.gugucon.kiot.domain.data.entity;

import com.gugucon.kiot.domain.coordinate.entity.Coordinate;
import jakarta.persistence.*;
import lombok.Getter;

@Entity
@Getter
public class Bluetooth {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "bluetooth_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "coordinate_id")
    private Coordinate coordinate;
}
