package com.gugucon.kiot.global.oauth;

import com.gugucon.kiot.global.redis.RedisUtils;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
@RequiredArgsConstructor
public class CustomSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    private final RedisUtils redisUtils;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException {

        CustomOAuth2User customOAuth2User = (CustomOAuth2User) authentication.getPrincipal();

        Long memberId = customOAuth2User.getMemberId();
        MemberDTO memberDTO = customOAuth2User.getMemberDTO();

        String code = request.getParameter("code");

        redisUtils.setData(code,memberDTO, 10);

        response.sendRedirect("giutgiot://callback?code=" + code);
    }
}
