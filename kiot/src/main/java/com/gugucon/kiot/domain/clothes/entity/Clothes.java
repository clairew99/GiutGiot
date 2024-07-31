package com.gugucon.kiot.domain.clothes.entity;

import com.gugucon.kiot.domain.clothes.enums.Category;
import com.gugucon.kiot.domain.clothes.enums.Color;
import com.gugucon.kiot.domain.clothes.enums.Pattern;
import com.gugucon.kiot.domain.clothes.enums.Type;
import com.gugucon.kiot.domain.user.entity.Member;
import jakarta.persistence.*;
import lombok.Getter;

@Entity
@Getter
public class Clothes {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "clothes_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id")
    private Member member;

    private Boolean isTop;

    @Enumerated(EnumType.STRING)
    private Color color;

    @Enumerated(EnumType.STRING)
    private Type type;

    @Enumerated(EnumType.STRING)
    private Category category;

    @Enumerated(EnumType.STRING)
    private Pattern pattern;

}
