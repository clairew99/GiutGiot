package com.gugucon.kiot.domain.data.service;

import com.gugucon.kiot.domain.coordinate.entity.Coordinate;
import com.gugucon.kiot.domain.coordinate.entity.CoordinateId;
import com.gugucon.kiot.domain.coordinate.enums.Pose;
import com.gugucon.kiot.domain.coordinate.repository.CoordinateRepository;
import com.gugucon.kiot.domain.data.entity.Voice;
import com.gugucon.kiot.domain.data.entity.VoiceId;
import com.gugucon.kiot.domain.data.dto.VoiceAddReq;
import com.gugucon.kiot.domain.data.repository.VoiceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class VoiceService {

    private final VoiceRepository voiceRepository;
    private final CoordinateRepository coordinateRepository;

    public void saveVoiceData(VoiceAddReq request, Long memberId) {

        CoordinateId coordinateId = new CoordinateId(memberId, request.getDate());

        Coordinate coordinate = coordinateRepository.findById(coordinateId)
                .orElseGet(() -> {
                    Coordinate c = new Coordinate(coordinateId, null, null, Pose.SITTING);
                    coordinateRepository.save(c);
                    return c;
                });

        for (int i = 0; i < request.getVoiceList().size(); i++) {
            VoiceId voiceId = new VoiceId(i + 1, request.getDate(), memberId);
            Voice voice = new Voice(voiceId, request.getVoiceList().get(i));
            voiceRepository.save(voice);
        }
    }
}
