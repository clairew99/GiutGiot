package com.gugucon.kiot.domain.coordinate.controller;

import com.epages.restdocs.apispec.ResourceSnippetParameters;
import com.epages.restdocs.apispec.Schema;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.gugucon.kiot.global.jwt.JwtTokenProvider;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.restdocs.AutoConfigureRestDocs;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.restdocs.payload.JsonFieldType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;

import static com.epages.restdocs.apispec.MockMvcRestDocumentationWrapper.document;
import static com.epages.restdocs.apispec.ResourceDocumentation.resource;
import static org.springframework.restdocs.headers.HeaderDocumentation.headerWithName;
import static org.springframework.restdocs.mockmvc.RestDocumentationRequestBuilders.*;
import static org.springframework.restdocs.operation.preprocess.Preprocessors.*;
import static org.springframework.restdocs.operation.preprocess.Preprocessors.prettyPrint;
import static org.springframework.restdocs.payload.PayloadDocumentation.fieldWithPath;
import static org.springframework.restdocs.request.RequestDocumentation.parameterWithName;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@Transactional
@SpringBootTest
@AutoConfigureMockMvc
@AutoConfigureRestDocs
public class CoordinateControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private Gson gson;

    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    private String jwtToken;

    @BeforeEach
    public void init() {
        jwtToken = jwtTokenProvider.createAccessToken(1L);
    }

    @Test
    @DisplayName("코디 등록 - 성공")
    public void coordinate_add_success() throws Exception {

        //given
        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("topId", 10001L);
        jsonObject.addProperty("bottomId", 11001L);
        jsonObject.addProperty("date", "2024-08-01");
        String content = gson.toJson(jsonObject);

        //when
        ResultActions actions = mockMvc.perform(
                post("/coordinates")
                        .header("Authorization", jwtToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON)
                        .content(content));

        //then
        actions
                .andExpect(status().isCreated())
                .andDo(document(
                        "코디 등록",
                        preprocessRequest(prettyPrint()),
                        preprocessResponse(prettyPrint()),
                        resource(ResourceSnippetParameters.builder()
                                .tag("Coordinate API")
                                .summary("코디 등록 API")
                                .requestHeaders(
                                        headerWithName("Authorization").description("JWT 토큰")
                                )
                                .requestFields(
                                        fieldWithPath("topId").type(JsonFieldType.NUMBER)
                                                .description("상의 ID"),
                                        fieldWithPath("bottomId").type(JsonFieldType.NUMBER)
                                                .description("하의 ID"),
                                        fieldWithPath("date").type(JsonFieldType.STRING)
                                                .description("날짜")
                                )
                                .requestSchema(Schema.schema("코디 등록 Request"))
                                .responseSchema(Schema.schema("코디 등록 Response"))
                                .build()
                        ))
                );
    }

    @Test
    @DisplayName("코디 월별 조회 - 성공")
    public void coordinate_list_success() throws Exception {

        //given
        String year = String.valueOf(LocalDate.now().getYear());
        String month = String.valueOf(LocalDate.now().getMonthValue());
        String day = String.valueOf(LocalDate.now().getDayOfMonth());

        //when
        ResultActions actions = mockMvc.perform(
                get("/coordinates")
                        .param("year", year)
                        .param("month", month)
                        .param("day", day)
                        .header("Authorization", jwtToken)
                        .accept(MediaType.APPLICATION_JSON));

        //then
        actions
                .andExpect(status().isOk())
                .andDo(document(
                        "코디 월별 조회",
                        preprocessRequest(prettyPrint()),
                        preprocessResponse(prettyPrint()),
                        resource(ResourceSnippetParameters.builder()
                                .tag("Coordinate API")
                                .summary("코디 월별 조회 API")
                                .requestHeaders(
                                        headerWithName("Authorization").description("JWT 토큰")
                                )
                                .queryParameters(
                                        parameterWithName("year").description("연도"),
                                        parameterWithName("month").description("월"),
                                        parameterWithName("day").description("일")
                                )
                                .responseFields(
                                        fieldWithPath("coordinates").type(JsonFieldType.ARRAY)
                                                .description("코디 리스트"),
                                        fieldWithPath("coordinates[].topColor").type(JsonFieldType.STRING)
                                                .description("상의 색").optional(),
                                        fieldWithPath("coordinates[].bottomColor").type(JsonFieldType.STRING)
                                                .description("하의 색").optional(),
                                        fieldWithPath("coordinates[].date").type(JsonFieldType.STRING)
                                                .description("날짜").optional(),
                                        fieldWithPath("startOfWeek").type(JsonFieldType.STRING)
                                                .description("시작날짜"),
                                        fieldWithPath("endOfTwoWeeks").type(JsonFieldType.STRING)
                                                .description("마지막날짜"),
                                        fieldWithPath("coordinates[].pose").type(JsonFieldType.STRING)
                                                .description("포즈")
                                )
                                .requestSchema(Schema.schema("코디 월별 조회 Request"))
                                .responseSchema(Schema.schema("코디 월별 조회 Response"))
                                .build()
                        ))
                );
    }

    @Test
    @DisplayName("코디 일별 조회 - 성공")
    public void coordinate_details_success() throws Exception {

        //given
        LocalDate now = LocalDate.of(2024, 8, 1);
        String year = String.valueOf(now.getYear());
        String month = String.valueOf(now.getMonthValue());
        String day = String.valueOf(now.getDayOfMonth());

        //when
        ResultActions actions = mockMvc.perform(
                get("/coordinates/daily")
                        .param("year", year)
                        .param("month", month)
                        .param("day", day)
                        .header("Authorization", jwtToken)
                        .accept(MediaType.APPLICATION_JSON));

        //then
        actions
                .andExpect(status().isOk())
                .andDo(document(
                        "코디 일별 조회",
                        preprocessRequest(prettyPrint()),
                        preprocessResponse(prettyPrint()),
                        resource(ResourceSnippetParameters.builder()
                                .tag("Coordinate API")
                                .summary("코디 일별 조회 API")
                                .requestHeaders(
                                        headerWithName("Authorization").description("JWT 토큰")
                                )
                                .queryParameters(
                                        parameterWithName("year").description("연도"),
                                        parameterWithName("month").description("월"),
                                        parameterWithName("day").description("일")
                                )
                                .responseFields(
                                        fieldWithPath("topId").type(JsonFieldType.NUMBER)
                                                .description("상의 ID"),
                                        fieldWithPath("topColor").type(JsonFieldType.STRING)
                                                .description("상의 색"),
                                        fieldWithPath("topCategory").type(JsonFieldType.STRING)
                                                .description("상의 카테고리"),
                                        fieldWithPath("topType").type(JsonFieldType.STRING)
                                                .description("상의 타입"),
                                        fieldWithPath("topPattern").type(JsonFieldType.STRING)
                                                .description("상의 패턴"),
                                        fieldWithPath("bottomId").type(JsonFieldType.NUMBER)
                                                .description("하의 ID"),
                                        fieldWithPath("bottomColor").type(JsonFieldType.STRING)
                                                .description("하의 색"),
                                        fieldWithPath("bottomCategory").type(JsonFieldType.STRING)
                                                .description("하의 카테고리"),
                                        fieldWithPath("bottomType").type(JsonFieldType.STRING)
                                                .description("하의 타입"),
                                        fieldWithPath("bottomPattern").type(JsonFieldType.STRING)
                                                .description("하의 패턴"),
                                        fieldWithPath("pose").type(JsonFieldType.STRING)
                                                .description("활동량 포즈")
                                )
                                .requestSchema(Schema.schema("코디 일별 조회 Request"))
                                .responseSchema(Schema.schema("코디 일별 조회 Response"))
                                .build()
                        ))
                );
    }


    @Test
    @DisplayName("코디 수정 - 성공")
    public void coordinate_modify_success() throws Exception {

        //given
        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("date", LocalDate.of(2024, 8, 1).toString());
        jsonObject.addProperty("topColor", "BLACK");
        jsonObject.addProperty("topCategory", "LONG");
        jsonObject.addProperty("topType", "SHIRTS");
        jsonObject.addProperty("topPattern", "CHECK");
        jsonObject.addProperty("bottomColor", "BLACK");
        jsonObject.addProperty("bottomCategory", "SHORT");
        jsonObject.addProperty("bottomType", "PANTS");
        jsonObject.addProperty("bottomPattern", "CHECK");
        String content = gson.toJson(jsonObject);

        //when
        ResultActions actions = mockMvc.perform(
                patch("/coordinates")
                        .header("Authorization", jwtToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON)
                        .content(content));

        //then
        actions
                .andExpect(status().isOk())
                .andDo(document(
                        "코디 수정",
                        preprocessRequest(prettyPrint()),
                        preprocessResponse(prettyPrint()),
                        resource(ResourceSnippetParameters.builder()
                                .tag("Coordinate API")
                                .summary("코디 수정 API")
                                .requestHeaders(
                                        headerWithName("Authorization").description("JWT 토큰")
                                )
                                .requestFields(
                                        fieldWithPath("date").type(JsonFieldType.STRING)
                                                .description("수정할 날짜"),
                                        fieldWithPath("topColor").type(JsonFieldType.STRING)
                                                .description("상의 색").optional(),
                                        fieldWithPath("topCategory").type(JsonFieldType.STRING)
                                                .description("상의 카테고리").optional(),
                                        fieldWithPath("topType").type(JsonFieldType.STRING)
                                                .description("상의 종류").optional(),
                                        fieldWithPath("topPattern").type(JsonFieldType.STRING)
                                                .description("상의 패턴").optional(),
                                        fieldWithPath("bottomColor").type(JsonFieldType.STRING)
                                                .description("하의 색").optional(),
                                        fieldWithPath("bottomCategory").type(JsonFieldType.STRING)
                                                .description("하의 카테고리").optional(),
                                        fieldWithPath("bottomType").type(JsonFieldType.STRING)
                                                .description("하의 종류").optional(),
                                        fieldWithPath("bottomPattern").type(JsonFieldType.STRING)
                                                .description("하의 패턴").optional()
                                )
                                .responseFields(
                                        fieldWithPath("topColor").type(JsonFieldType.STRING)
                                                .description("상의 색"),
                                        fieldWithPath("topCategory").type(JsonFieldType.STRING)
                                                .description("상의 카테고리"),
                                        fieldWithPath("topType").type(JsonFieldType.STRING)
                                                .description("상의 타입"),
                                        fieldWithPath("topPattern").type(JsonFieldType.STRING)
                                                .description("상의 패턴"),
                                        fieldWithPath("bottomColor").type(JsonFieldType.STRING)
                                                .description("하의 색"),
                                        fieldWithPath("bottomCategory").type(JsonFieldType.STRING)
                                                .description("하의 카테고리"),
                                        fieldWithPath("bottomType").type(JsonFieldType.STRING)
                                                .description("하의 타입"),
                                        fieldWithPath("bottomPattern").type(JsonFieldType.STRING)
                                                .description("하의 패턴")
                                )
                                .requestSchema(Schema.schema("코디 수정 Request"))
                                .responseSchema(Schema.schema("코디 수정 Response"))
                                .build()
                        ))
                );
    }
}