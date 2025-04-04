package com.gugucon.kiot.global.redis;

import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;

@Component
@RequiredArgsConstructor
public class RedisUtils {
    private final RedisTemplate<String, Object> redisTemplate;

    public void setData(String key, Object value, long duration){
        redisTemplate.opsForValue().set(key, value, duration, TimeUnit.SECONDS);
    }

    public Object getData(String key){
        return redisTemplate.opsForValue().get(key);
    }
}
