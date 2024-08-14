package com.gugucon.kiot.domain.coordinate.repository;

import com.gugucon.kiot.domain.clothes.entity.Clothes;
import com.gugucon.kiot.domain.coordinate.entity.Coordinate;
import com.gugucon.kiot.domain.coordinate.entity.CoordinateId;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface CoordinateRepository extends JpaRepository<Coordinate, CoordinateId> {
    @EntityGraph(attributePaths = {"top", "bottom"})
    List<Coordinate> findByIdMemberIdAndIdDateBetween(Long memberId, LocalDate startDate, LocalDate endDate);

    @EntityGraph(attributePaths = {"top", "bottom"})
    Optional<Coordinate> findByIdMemberIdAndIdDate(Long memberId, LocalDate date);

    @Query("SELECT id.date as date " +
            "FROM Coordinate " +
            "WHERE id.memberId = :memberId " +
            "AND (top.id = :clothesId " +
            "OR bottom.id = :clothesId) " +
            "ORDER BY id.date " +
            "DESC LIMIT 1")
    Optional<LocalDate> findLatestDateByMemberIdAndClothesId(Long memberId, Long clothesId);

    @EntityGraph(attributePaths = {"top", "bottom"})
    @Query("SELECT c " +
            "FROM Coordinate c " +
            "LEFT JOIN FETCH Clothes cl ON c.top = cl " +
            "LEFT JOIN FETCH Voice v ON v.id.date = c.id.date AND v.id.memberId = c.id.memberId OR c.bottom = cl " +
            "WHERE c.id.memberId = :memberId " +
            "AND c.id.date " +
            "BETWEEN :aWeekAgo " +
            "AND :today")
    List<Coordinate> findCoordinateLastWeek(long memberId, LocalDate today, LocalDate aWeekAgo);

    @Query("SELECT c " +
            "FROM Coordinate c " +
            "LEFT JOIN FETCH Clothes cl ON c.top = cl " +
            "LEFT JOIN FETCH Voice v ON v.id.date = c.id.date AND v.id.memberId = c.id.memberId OR c.bottom = cl " +
            "WHERE c.id.memberId = :memberId " +
            "AND c.id.date >= :before45")
    List<Coordinate> findCoordinatesLast45(Long memberId, LocalDate before45);

    @Query("SELECT c.id.date " +
            "FROM Coordinate c " +
            "WHERE c.id.memberId = :memberId " +
            "AND c.top.id = :topId " +
            "AND c.bottom.id = :bottomId " +
            "ORDER BY c.id.date " +
            "DESC LIMIT 1")
    LocalDate findLastwornByTopAndBottom(Long memberId, Long topId, Long bottomId);

    @Query("SELECT c " +
            "FROM Coordinate c " +
            "WHERE c.top = :clothes " +
            "OR c.bottom = :clothes " +
            "ORDER BY c.id.date " +
            "DESC LIMIT 2")
    List<Coordinate> findLastWornCoordinates(@Param("clothes") Clothes clothes);

    @Modifying
    void deleteAllByIdMemberId(Long memberId);
}