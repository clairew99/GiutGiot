package com.gugucon.kiot.global.oauth;

import com.gugucon.kiot.domain.member.entity.Member;
import com.gugucon.kiot.domain.member.repository.MemberRepository;
import com.gugucon.kiot.global.oauth.response.GoogleResponse;
import com.gugucon.kiot.global.oauth.response.KakaoResponse;
import com.gugucon.kiot.global.oauth.response.NaverResponse;
import com.gugucon.kiot.global.oauth.response.OAuth2Response;
import lombok.RequiredArgsConstructor;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final MemberRepository memberRepository;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {

        OAuth2User oAuth2User = super.loadUser(userRequest);

        String registration = userRequest.getClientRegistration().getRegistrationId();

        OAuth2Response oAuth2Response = null;

        switch (registration) {
            case "naver" -> oAuth2Response = new NaverResponse(oAuth2User.getAttributes());
            case "kakao" -> oAuth2Response = new KakaoResponse(oAuth2User.getAttributes());
            case "google" -> oAuth2Response = new GoogleResponse(oAuth2User.getAttributes());
        }

        if (oAuth2Response == null) return null;

        String email = oAuth2Response.getEmail();

        Optional<Member> oMember = memberRepository.findByEmail(email);

        MemberDTO memberDTO = null;

        if (oMember.isPresent()) {
            Member member = oMember.get();
            memberDTO = MemberDTO.of(member);
        } else {
            memberDTO = new MemberDTO(oAuth2Response);
            Member member = memberRepository.save(memberDTO.toEntity());
            memberDTO.setId(member.getId());
        }

        return new CustomOAuth2User(memberDTO);
    }
}
