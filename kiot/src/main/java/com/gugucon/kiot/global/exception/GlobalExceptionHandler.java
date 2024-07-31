package com.gugucon.kiot.global.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import static com.gugucon.kiot.global.exception.ErrorCode.GLOBAL_EXCEPTION;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> basicExceptionHandler(Exception e) {

        ErrorResponse errorResponse = new ErrorResponse(GLOBAL_EXCEPTION, e.getClass().getSimpleName());

        return new ResponseEntity<>(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @ExceptionHandler(BusinessLogicException.class)
    public ResponseEntity<ErrorResponse> businessExceptionHandler(BusinessLogicException e) {

        ErrorResponse errorResponse = new ErrorResponse(e.getErrorCode(), e.getClass().getSimpleName());

        return new ResponseEntity<>(errorResponse, HttpStatus.valueOf(errorResponse.getStatus()));
    }
}
