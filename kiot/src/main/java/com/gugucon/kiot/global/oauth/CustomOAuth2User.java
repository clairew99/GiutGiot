package com.gugucon.kiot.global.oauth;

import lombok.AllArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.oauth2.core.user.OAuth2User;

import java.util.Collection;
import java.util.Map;

@AllArgsConstructor
public class CustomOAuth2User implements OAuth2User {

    private MemberDTO memberDTO;

    @Override
    public Map<String, Object> getAttributes() {
        return null;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return null;
    }

    @Override
    public String getName() {
        return memberDTO.getNickname();
    }

    public String getEmail() {
        return memberDTO.getEmail();
    }

    public Long getMemberId() {
        return memberDTO.getId();
    }

    public MemberDTO getMemberDTO() {
        return memberDTO;
    }
}
