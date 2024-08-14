package com.gugucon.kiot.domain.data.repository;

import com.gugucon.kiot.domain.data.entity.Voice;
import com.gugucon.kiot.domain.data.entity.VoiceId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

import java.time.LocalDate;

public interface VoiceRepository extends JpaRepository<Voice, VoiceId> {

    @Query("SELECT v FROM Voice v WHERE (v.id.memberId = :memberId) AND (v.id.date = :lastworn)")
    List<Voice> findByDate(Long memberId, LocalDate lastworn);

    @Modifying
    void deleteAllByIdMemberId(Long memberId);
}
