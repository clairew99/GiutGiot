package com.gugucon.kiot.global.jwt;

import com.gugucon.kiot.domain.member.entity.Member;
import com.gugucon.kiot.domain.member.repository.MemberRepository;
import com.gugucon.kiot.global.exception.BusinessLogicException;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Service;

import java.util.Collections;

import static com.gugucon.kiot.global.exception.ErrorCode.NOT_FOUND;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final MemberRepository memberRepository;

    @Override
    public UserDetails loadUserByUsername(String memberId) {

        Long id = Long.parseLong(memberId);
        Member member = memberRepository.findById(id)
                .orElseThrow(() -> new BusinessLogicException(NOT_FOUND));

        return new CustomUserDetails(member.getId(), Collections.singletonList(new SimpleGrantedAuthority("ROLE_USER")));
    }
}
