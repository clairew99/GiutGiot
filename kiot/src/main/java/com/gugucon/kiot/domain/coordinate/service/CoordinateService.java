package com.gugucon.kiot.domain.coordinate.service;

import com.gugucon.kiot.domain.coordinate.dto.*;

public interface CoordinateService {

    void addCoordinate(CoordinateAddReq req, Long memberId);

    CoordinateListRes findTwoWeeksCoordinates(Long memberId, Integer year, Integer month, Integer day);

    CoordinateDetailRes getCoordinateDetail(Long memberId, Integer year, Integer month, Integer day);

    CoordinateModifyRes modifyCoordinate(Long memberId, CoordinateModifyReq req);
}