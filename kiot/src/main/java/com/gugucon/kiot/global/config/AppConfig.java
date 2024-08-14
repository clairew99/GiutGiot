package com.gugucon.kiot.global.config;

import com.gugucon.kiot.global.logtrace.LogTrace;
import com.gugucon.kiot.global.logtrace.LogTraceAspect;
import com.gugucon.kiot.global.p6spy.P6spySqlFormatConfiguration;
import com.p6spy.engine.spy.P6SpyOptions;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@RequiredArgsConstructor
public class AppConfig {
    private final LogTrace logTrace;

    @Bean
    @ConditionalOnProperty(value = "logTrace", havingValue = "true")
    public LogTraceAspect logTraceAspect() {
        return new LogTraceAspect(logTrace);
    }

    @PostConstruct
    public void setLogMessageFormat() {
        P6SpyOptions.getActiveInstance().setLogMessageFormat(P6spySqlFormatConfiguration.class.getName());
    }
}