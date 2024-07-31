package com.gugucon.kiot.global.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class ErrorResponse {

    private int status;

    private String message;

    private String details;

    public ErrorResponse(ErrorCode errorCode, String details) {
        this.status = errorCode.getStatus();
        this.message = errorCode.getMessage();
        this.details = details;
    }
}
