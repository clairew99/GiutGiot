package com.gugucon.kiot.global.jwt;
import com.gugucon.kiot.domain.member.dto.LoginReq;
import com.gugucon.kiot.domain.member.dto.LoginRes;
import com.gugucon.kiot.domain.member.service.MemberService;
import com.gugucon.kiot.global.exception.BusinessLogicException;
import com.gugucon.kiot.global.redis.RedisUtils;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

import static com.gugucon.kiot.global.exception.ErrorCode.LOGIN_FAILED;
import static org.springframework.http.HttpStatus.OK;

@RestController
@RequestMapping("/login")
@RequiredArgsConstructor
public class LoginController {

    private final MemberService memberService;
    private final JwtTokenProvider jwtTokenProvider;
    private final RedisUtils redisUtils;

    @Value("${jwt.refresh_expiration}")
    private Long refreshExpiration;

    @PostMapping("/temp")
    public Map<String, String> login(@RequestParam Long memberId,
                                     @RequestParam(required = false) String password) {

        String accessToken = jwtTokenProvider.createAccessToken(memberId);
        String refreshToken = jwtTokenProvider.createRefreshToken(memberId);

        Map<String, String> tokens = new HashMap<>();
        tokens.put("accessToken", accessToken);
        tokens.put("refreshToken", refreshToken);

        return tokens;
    }

    @PostMapping("/refresh")
    public ResponseEntity<?> refresh(
            @RequestHeader String refresh,
            HttpServletResponse response) {

        if (jwtTokenProvider.validateToken(refresh)) {
            Long memberId = jwtTokenProvider.getMemberId(refresh);

            String redisToken = (String) redisUtils.getData("refresh:" + memberId);

            if (!refresh.equals(redisToken)) {
                throw new BusinessLogicException(LOGIN_FAILED);
            }

            String accessToken = jwtTokenProvider.createAccessToken(memberId);
            String refreshToken = jwtTokenProvider.createRefreshToken(memberId);

            response.setHeader("Authorization", accessToken);
            response.addCookie(new Cookie("refresh", refreshToken));

            redisUtils.setData("refresh:" + memberId, refreshToken, refreshExpiration);
        } else {
            throw new BusinessLogicException(LOGIN_FAILED);
        }

        return new ResponseEntity<>(null, OK);
    }

    @PostMapping
    public ResponseEntity<LoginRes> login(
            @RequestBody LoginReq loginReq,
            HttpServletResponse response) {

        LoginRes res = memberService.login(loginReq);

        String accessToken = jwtTokenProvider.createAccessToken(res.getMemberId());
        String refreshToken = jwtTokenProvider.createRefreshToken(res.getMemberId());

        response.setHeader("Authorization", accessToken);
        response.addCookie(new Cookie("refresh", refreshToken));

        redisUtils.setData("refresh:" + res.getMemberId(), refreshToken, refreshExpiration);

        return new ResponseEntity<>(res, OK);
    }
}
