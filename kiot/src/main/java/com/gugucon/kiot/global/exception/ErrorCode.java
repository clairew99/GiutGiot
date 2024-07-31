package com.gugucon.kiot.global.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum ErrorCode {
    GLOBAL_EXCEPTION(500, "알 수 없는 오류"),
    BAD_REQUEST(400, "잘못된 요청입니다.")
    ;

    private final int status;
    private final String message;
}
