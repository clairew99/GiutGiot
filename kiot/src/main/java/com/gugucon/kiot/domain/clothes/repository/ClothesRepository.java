package com.gugucon.kiot.domain.clothes.repository;

import com.gugucon.kiot.domain.clothes.entity.Clothes;
import com.gugucon.kiot.domain.clothes.enums.Category;
import com.gugucon.kiot.domain.clothes.enums.Color;
import com.gugucon.kiot.domain.clothes.enums.Pattern;
import com.gugucon.kiot.domain.clothes.enums.Type;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface ClothesRepository extends JpaRepository<Clothes, Long> {

    @EntityGraph(attributePaths = "member")
    @Query("SELECT c FROM Clothes c WHERE c.id = :clothesId")
    Optional<Clothes> findByIdWithMember(@Param("clothesId") Long clothesId);

    @Query("SELECT c FROM Clothes c WHERE c.member.id = :memberId AND c.isTop = :isTop AND c.color = :color AND c.type = :type AND c.category = :category AND (:pattern IS NULL OR c.pattern = :pattern)")
    Optional<Clothes> findClothes(Long memberId, Boolean isTop, Color color, Type type, Category category, Pattern pattern);

    @Query("SELECT c FROM Clothes c JOIN Coordinate cd on cd.top = c or cd.bottom = c WHERE c.member.id = :memberId AND cd.id.date BETWEEN :aWeekAgo AND :today")
    List<Clothes> findWornClothesLastWeek(long memberId, LocalDate today, LocalDate aWeekAgo);

    @Modifying
    void deleteAllByMemberId(Long memberId);
}
