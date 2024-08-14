package com.gugucon.kiot.domain.data.service;

import com.gugucon.kiot.domain.coordinate.entity.Coordinate;
import com.gugucon.kiot.domain.coordinate.entity.CoordinateId;
import com.gugucon.kiot.domain.coordinate.enums.Pose;
import com.gugucon.kiot.domain.coordinate.repository.CoordinateRepository;
import com.gugucon.kiot.domain.data.dto.ActivityAddReq;
import com.gugucon.kiot.domain.data.entity.Activity;
import com.gugucon.kiot.domain.data.entity.ActivityId;
import com.gugucon.kiot.domain.data.repository.ActivityRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ActivityService {

    private final ActivityRepository activityRepository;
    private final CoordinateRepository coordinateRepository;

    public void saveActivity(ActivityAddReq request, Long memberId) {

        CoordinateId coordinateId = new CoordinateId(memberId, request.getDate());

        Coordinate coordinate = coordinateRepository.findById(coordinateId)
                .orElseGet(() -> {
                    Coordinate c = new Coordinate(coordinateId, null, null, Pose.SITTING);
                    coordinateRepository.save(c);
                    return c;
                });

        ActivityId activityId = new ActivityId(request.getDate(), memberId);

        Activity activity = activityRepository.findById(activityId)
                .orElseGet(() -> new Activity(activityId, 0));

        activity.addTime(request.getTime());

        activityRepository.save(activity);

        if(activity.getTime() > 3600000) {
            coordinate.updatePose(Pose.RUNNING);
        } else if(activity.getTime() > 1800000) {
            coordinate.updatePose(Pose.STANDING);
        } else {
            coordinate.updatePose(Pose.SITTING);
        }

        coordinateRepository.save(coordinate);
    }

}