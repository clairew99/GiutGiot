package com.gugucon.kiot.domain.clothes.controller;

import com.epages.restdocs.apispec.ResourceSnippetParameters;
import com.epages.restdocs.apispec.Schema;
import com.google.gson.Gson;
import com.gugucon.kiot.domain.clothes.dto.ClothesAddReq;
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
public class ClothesControllerTest {

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
    @DisplayName("옷 생성 - 성공")
    public void clothes_add_success() throws Exception {

        //given
        ClothesAddReq clothesAddReq = new ClothesAddReq();
        clothesAddReq.setIsTop(true);
        clothesAddReq.setColor("RED");
        clothesAddReq.setCategory("HOODIE");
        clothesAddReq.setType("LONG");
        clothesAddReq.setPattern("CHECK");
        String content = gson.toJson(clothesAddReq);

        //when
        ResultActions actions = mockMvc.perform(
                post("/clothes")
                        .header("Authorization", jwtToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON)
                        .content(content));

        //then
        actions
                .andExpect(status().isCreated())
                .andDo(document(
                        "새 옷 등록",
                        preprocessRequest(prettyPrint()),
                        preprocessResponse(prettyPrint()),
                        resource(ResourceSnippetParameters.builder()
                                .tag("Clothes API")
                                .summary("새 옷 등록 API")
                                .requestHeaders(
                                        headerWithName("Authorization").description("JWT 토큰")
                                )
                                .requestFields(
                                        fieldWithPath("isTop").type(JsonFieldType.BOOLEAN)
                                                .description("상의 여부"),
                                        fieldWithPath("color").type(JsonFieldType.STRING)
                                                .description("옷 색상"),
                                        fieldWithPath("category").type(JsonFieldType.STRING)
                                                .description("카테고리"),
                                        fieldWithPath("type").type(JsonFieldType.STRING)
                                                .description("타입"),
                                        fieldWithPath("pattern").type(JsonFieldType.STRING)
                                                .description("패턴")
                                )
                                .responseFields(
                                        fieldWithPath("clothesId").type(JsonFieldType.NUMBER)
                                                .description("옷 ID")
                                )
                                .requestSchema(Schema.schema("새 옷 등록 Request"))
                                .responseSchema(Schema.schema("새 옷 등록 Response"))
                                .build()
                        ))
                );
    }

    @Test
    @DisplayName("옷 상세조회 - 성공")
    public void clothes_details_success() throws Exception {

        //given
        Long clothesId = 10001L;

        //when
        ResultActions actions = mockMvc.perform(
                get("/clothes/{clothesId}", clothesId)
                        .header("Authorization", jwtToken)
                        .accept(MediaType.APPLICATION_JSON));

        //then
        actions
                .andExpect(status().isOk())
                .andDo(document(
                        "옷 상세조회",
                        preprocessRequest(prettyPrint()),
                        preprocessResponse(prettyPrint()),
                        resource(ResourceSnippetParameters.builder()
                                .tag("Clothes API")
                                .summary("옷 상세조회 API")
                                .requestHeaders(
                                        headerWithName("Authorization").description("JWT 토큰")
                                )
                                .pathParameters(
                                        parameterWithName("clothesId").description("옷 ID")
                                )
                                .responseFields(
                                        fieldWithPath("clothesId").type(JsonFieldType.NUMBER)
                                                .description("옷 ID"),
                                        fieldWithPath("isTop").type(JsonFieldType.BOOLEAN)
                                                .description("상의 여부"),
                                        fieldWithPath("color").type(JsonFieldType.STRING)
                                                .description("옷 색상"),
                                        fieldWithPath("category").type(JsonFieldType.STRING)
                                                .description("카테고리"),
                                        fieldWithPath("type").type(JsonFieldType.STRING)
                                                .description("타입"),
                                        fieldWithPath("pattern").type(JsonFieldType.STRING)
                                                .description("패턴"),
                                        fieldWithPath("lastWorn").type(JsonFieldType.STRING)
                                                .description("마지막으로 입은 날짜"),
                                        fieldWithPath("conversationCount").type(JsonFieldType.NUMBER)
                                                .description("대화 인원"),
                                        fieldWithPath("conversationTime").type(JsonFieldType.NUMBER)
                                                .description("총 대화 시간"),
                                        fieldWithPath("walkingTime").type(JsonFieldType.NUMBER)
                                                .description("걸음 시간"),
                                        fieldWithPath("memory").type(JsonFieldType.NUMBER)
                                                .description("기억 정도"),
                                        fieldWithPath("leftTime").type(JsonFieldType.NUMBER)
                                                .description("남은 시간")
                                )
                                .requestSchema(Schema.schema("옷 상세조회 Request"))
                                .responseSchema(Schema.schema("옷 상세조회 Response"))
                                .build()
                        ))
                );
    }

    @Test
    @DisplayName("옷 예측 - 성공")
    public void clothes_prediction_list_success() throws Exception {

        //given

        //when
        ResultActions actions = mockMvc.perform(
                get("/clothes/prediction")
                        .header("Authorization", jwtToken)
                        .accept(MediaType.APPLICATION_JSON));

        //then
        actions
                .andExpect(status().isOk())
                .andDo(document(
                        "옷 예측",
                        preprocessRequest(prettyPrint()),
                        preprocessResponse(prettyPrint()),
                        resource(ResourceSnippetParameters.builder()
                                .tag("Clothes API")
                                .summary("옷 예측 API")
                                .requestHeaders(
                                        headerWithName("Authorization").description("JWT 토큰")
                                )
                                .responseFields(
                                        fieldWithPath("predictionList").type(JsonFieldType.ARRAY)
                                                .description("예측 목록"),
                                        fieldWithPath("predictionList[].top").type(JsonFieldType.OBJECT)
                                                .description("예측 상의"),
                                        fieldWithPath("predictionList[].bottom").type(JsonFieldType.OBJECT)
                                                .description("예측 하의"),
                                        fieldWithPath("predictionList[].top.clothesId").type(JsonFieldType.NUMBER)
                                                .description("옷 ID"),
                                        fieldWithPath("predictionList[].top.isTop").type(JsonFieldType.BOOLEAN)
                                                .description("상의 여부"),
                                        fieldWithPath("predictionList[].top.color").type(JsonFieldType.STRING)
                                                .description("옷 색상"),
                                        fieldWithPath("predictionList[].top.category").type(JsonFieldType.STRING)
                                                .description("카테고리"),
                                        fieldWithPath("predictionList[].top.type").type(JsonFieldType.STRING)
                                                .description("타입"),
                                        fieldWithPath("predictionList[].top.pattern").type(JsonFieldType.STRING)
                                                .description("패턴"),
                                        fieldWithPath("predictionList[].top.memory").type(JsonFieldType.NULL)
                                                .description("데이터 없음"),
                                        fieldWithPath("predictionList[].bottom.clothesId").type(JsonFieldType.NUMBER)
                                                .description("옷 ID"),
                                        fieldWithPath("predictionList[].bottom.isTop").type(JsonFieldType.BOOLEAN)
                                                .description("상의 여부"),
                                        fieldWithPath("predictionList[].bottom.color").type(JsonFieldType.STRING)
                                                .description("옷 색상"),
                                        fieldWithPath("predictionList[].bottom.category").type(JsonFieldType.STRING)
                                                .description("카테고리"),
                                        fieldWithPath("predictionList[].bottom.type").type(JsonFieldType.STRING)
                                                .description("타입"),
                                        fieldWithPath("predictionList[].bottom.pattern").type(JsonFieldType.STRING)
                                                .description("패턴"),
                                        fieldWithPath("predictionList[].bottom.memory").type(JsonFieldType.NULL)
                                                .description("데이터 없음")
                                )
                                .requestSchema(Schema.schema("옷 예측 Request"))
                                .responseSchema(Schema.schema("옷 예측 Response"))
                                .build()
                        ))
                );
    }

    @Test
    @DisplayName("기억도별 옷 조회 - 성공")
    public void remembered_clothes_list_success() throws Exception {

        //given

        //when
        ResultActions actions = mockMvc.perform(
                get("/clothes/memory")
                        .header("Authorization", jwtToken)
                        .accept(MediaType.APPLICATION_JSON));

        //then
        actions
                .andExpect(status().isOk())
                .andDo(document(
                        "기억도별 옷 조회",
                        preprocessRequest(prettyPrint()),
                        preprocessResponse(prettyPrint()),
                        resource(ResourceSnippetParameters.builder()
                                .tag("Clothes API")
                                .summary("기억도별 옷 조회 API")
                                .requestHeaders(
                                        headerWithName("Authorization").description("JWT 토큰")
                                )
                                .responseFields(
                                        fieldWithPath("rememberedClothesList").type(JsonFieldType.ARRAY)
                                                .description("기억되는 옷 리스트"),
                                        fieldWithPath("rememberedClothesList[].clothesId").type(JsonFieldType.NUMBER)
                                                .description("옷 ID").optional(),
                                        fieldWithPath("rememberedClothesList[].isTop").type(JsonFieldType.BOOLEAN)
                                                .description("상의 여부").optional(),
                                        fieldWithPath("rememberedClothesList[].color").type(JsonFieldType.STRING)
                                                .description("옷 색").optional(),
                                        fieldWithPath("rememberedClothesList[].category").type(JsonFieldType.STRING)
                                                .description("옷 카테고리").optional(),
                                        fieldWithPath("rememberedClothesList[].type").type(JsonFieldType.STRING)
                                                .description("옷 타입").optional(),
                                        fieldWithPath("rememberedClothesList[].pattern").type(JsonFieldType.STRING)
                                                .description("옷 패턴").optional(),
                                        fieldWithPath("rememberedClothesList[].memory").type(JsonFieldType.NUMBER)
                                                .description("옷 기억도").optional(),
                                        fieldWithPath("forgottenClothesList").type(JsonFieldType.ARRAY)
                                                .description("잊혀진 옷 리스트"),
                                        fieldWithPath("forgottenClothesList[].clothesId").type(JsonFieldType.NUMBER)
                                                .description("옷 ID").optional(),
                                        fieldWithPath("forgottenClothesList[].isTop").type(JsonFieldType.BOOLEAN)
                                                .description("상의 여부").optional(),
                                        fieldWithPath("forgottenClothesList[].color").type(JsonFieldType.STRING)
                                                .description("옷 색").optional(),
                                        fieldWithPath("forgottenClothesList[].category").type(JsonFieldType.STRING)
                                                .description("옷 카테고리").optional(),
                                        fieldWithPath("forgottenClothesList[].type").type(JsonFieldType.STRING)
                                                .description("옷 타입").optional(),
                                        fieldWithPath("forgottenClothesList[].pattern").type(JsonFieldType.STRING)
                                                .description("옷 패턴").optional(),
                                        fieldWithPath("forgottenClothesList[].memory").type(JsonFieldType.NUMBER)
                                                .description("옷 기억도").optional()
                                )
                                .requestSchema(Schema.schema("기억도별 옷 조회 Request"))
                                .responseSchema(Schema.schema("기억도별 옷 조회 Response"))
                                .build()
                        ))
                );
    }

    @Test
    @DisplayName("옷 확인 - 성공")
    public void clothes_check_success() throws Exception {

        //given
        ClothesAddReq clothesAddReq = new ClothesAddReq();
        clothesAddReq.setIsTop(true);
        clothesAddReq.setColor("BLACK");
        clothesAddReq.setCategory("SHIRT");
        clothesAddReq.setType("LONG");
        clothesAddReq.setPattern("STRIPE");
        String content = gson.toJson(clothesAddReq);

        //when
        ResultActions actions = mockMvc.perform(
                post("/clothes/check")
                        .header("Authorization", jwtToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON)
                        .content(content));

        //then
        actions
                .andExpect(status().isOk())
                .andDo(document(
                        "옷 착용 가능여부 확인",
                        preprocessRequest(prettyPrint()),
                        preprocessResponse(prettyPrint()),
                        resource(ResourceSnippetParameters.builder()
                                .tag("Clothes API")
                                .summary("옷 착용 가능여부 확인 API")
                                .requestHeaders(
                                        headerWithName("Authorization").description("JWT 토큰")
                                )
                                .requestFields(
                                        fieldWithPath("isTop").type(JsonFieldType.BOOLEAN)
                                                .description("상의 여부"),
                                        fieldWithPath("color").type(JsonFieldType.STRING)
                                                .description("옷 색상"),
                                        fieldWithPath("category").type(JsonFieldType.STRING)
                                                .description("카테고리"),
                                        fieldWithPath("type").type(JsonFieldType.STRING)
                                                .description("타입"),
                                        fieldWithPath("pattern").type(JsonFieldType.STRING)
                                                .description("패턴")
                                )
                                .responseFields(
                                        fieldWithPath("isAvailable").type(JsonFieldType.BOOLEAN)
                                                .description("착용가능 여부"),
                                        fieldWithPath("clothesId").type(JsonFieldType.NUMBER)
                                                .description("옷 ID").optional(),
                                        fieldWithPath("isTop").type(JsonFieldType.BOOLEAN)
                                                .description("상의 여부").optional()
                                )
                                .requestSchema(Schema.schema("옷 착용 가능여부 확인 Request"))
                                .responseSchema(Schema.schema("옷 착용 가능여부 확인 Response"))
                                .build()
                        ))
                );
    }

}