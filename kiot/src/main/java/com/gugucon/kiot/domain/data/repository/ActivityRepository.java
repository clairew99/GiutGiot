package com.gugucon.kiot.domain.data.repository;

import com.gugucon.kiot.domain.data.entity.Activity;
import com.gugucon.kiot.domain.data.entity.ActivityId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDate;
import java.util.Optional;

public interface ActivityRepository extends JpaRepository<Activity, ActivityId> {

    @Query("SELECT time FROM Activity WHERE (id.memberId = :memberId) AND (id.date = :lastworn)")
    Optional<Integer> findByDate(Long memberId, LocalDate lastworn);

    @Modifying
    void deleteAllByIdMemberId(Long memberId);
}
