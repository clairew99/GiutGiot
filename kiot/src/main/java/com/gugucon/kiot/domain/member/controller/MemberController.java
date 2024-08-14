package com.gugucon.kiot.domain.member.controller;

import com.gugucon.kiot.domain.member.dto.LoginReq;
import com.gugucon.kiot.domain.member.dto.LoginRes;
import com.gugucon.kiot.domain.member.dto.MemberFindRes;
import com.gugucon.kiot.domain.member.dto.MemberModifyReq;
import com.gugucon.kiot.domain.member.service.MemberService;
import com.gugucon.kiot.global.argumentresolver.LoginId;
import com.gugucon.kiot.global.jwt.JwtTokenProvider;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import static org.springframework.http.HttpStatus.NO_CONTENT;
import static org.springframework.http.HttpStatus.OK;

@RestController
@RequestMapping("/members")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;
    private final JwtTokenProvider jwtTokenProvider;

    @GetMapping
    public ResponseEntity<MemberFindRes> memberFind(@LoginId Long loginId) {

        MemberFindRes response = memberService.findMember(loginId);

        return new ResponseEntity<>(response, OK);
    }

    @PatchMapping
    public ResponseEntity<?> memberModify(
            @LoginId Long memberId,
            @RequestBody MemberModifyReq memberModifyReq) {

        memberService.modifyMember(memberId, memberModifyReq);

        return new ResponseEntity<>(null, OK);
    }

    @DeleteMapping
    public ResponseEntity<?> memberRemove(@LoginId Long memberId) {

        memberService.removeMember(memberId);

        return new ResponseEntity<>(null, NO_CONTENT);
    }

    @PostMapping("/login")
    public ResponseEntity<LoginRes> login(
            @RequestBody LoginReq loginReq,
            HttpServletResponse response) {

        LoginRes res = memberService.login(loginReq);

        response.setHeader("Authorization", jwtTokenProvider.createAccessToken(res.getMemberId()));
        response.addCookie(new Cookie("refresh", jwtTokenProvider.createRefreshToken(res.getMemberId())));

        return new ResponseEntity<>(res, OK);
    }
}
