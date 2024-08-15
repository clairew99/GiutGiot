# 👕서비스 소개

## 서비스 설명

### 개요

- 서비스 명 : 기웃기옷
- 한 줄 소개 : 음성 기반 옷 기억 서비스

### 타겟
- 매일 출근할 때 무엇을 입을지 고민되는 사람
- 스타일리쉬한 이미지를 쌓고 싶은 사람
- 어제 입은 옷도 잘 기억나지 않는 사람

# 👕기획 배경

## 배경
오늘 뭐 입지?<br>
매일 정기적으로 어딘가로 출근하고, 비슷한 사람을 만난다면 나갈 준비를 하며 이 고민을 한번쯤 해보셨을 겁니다.<br>
우리는 옷을 정하기 귀찮아 하면서도, 그렇다고 매일 같은 옷을 입고싶지는 않습니다. 자주 보는 사람들이 내 모습을 보고 '저 사람은 옷이 하나밖에 없나봐...' 라고 생각하는 건 싫기 때문이죠. <br>
당신만의 기깔나는 옷장, 기웃기옷은 당신이 입으려는 옷이 사람들의 기억에 남아있는지 알려줍니다. 만약 오늘 입으려는 옷이 아직 사람들의 기억에 남아있다면, 다른 옷을 선택해 좀 더 스타일리쉬한 이미지를 갖출 수 있어요. <br>
기웃기옷을 통해 단조로운 일상에 당신만의 스타일을 더해보세요.<br>

## 목적
- 사용자의 옷이 주변 사람들에게 얼마나 기억되었는지 알려주는 서비스
- 사용자가 코디를 쉽게 기록할 수 있는 서비스


# 👕기능 소개
### 1. 로그인

<img src="./assets/로그인.gif" height="500" alt="home"/><br>

- OAuth 를 활용한 Google, Naver, Kakao 로그인


### 2. 메인 페이지 (모래시계)

<img src="./assets/홈_화면.gif" height="500" alt="home"/>
<img src="./assets/설명1.gif" height="500" alt="tutorial1"/>
<img src="./assets/설명2.gif" height="500" alt="tutorial2"/>
<img src="./assets/설명3.gif" height="500" alt="tutorial3"/>
<br>

- 메인 페이지 시작 시 기억도가 낮은 구슬부터 내려옴
- 아직 사람들의 기억에 남아있는 옷은 모래시계 상단, 잊혀진 옷은 모래시계 하단에 위치
- 설명 구슬: 클릭 시 앱 동작 원리 설명

### 2-1. 메인 페이지 상세조회



- 각 구슬 클릭 시 옷 정보 상세조회 가능
- 입었던 옷 기억도 조회



### 3. 코디 등록
1) 음성으로 등록
    
<img src="./assets/음성등록.gif" height="500" alt="architecture"/><br>
- 사용자는 음성을 통해 그날의 코디 등록 <br>
ex: 나 오늘 빨간색 반팔 니트 입을래
- 서비스와의 대화를 통한 등록
    
2) 직접 등록

<img src="./assets/옷_직접등록.gif" height="500" alt="tutorial3"/><br>
    
- 상/하의, 색, 옷 종류를 직접 선택해 등록

### 4. 코디 캘린더
<br><img src="./assets/캘린더.gif" height="500" alt="calendar"/><br>
- 과거 2주일 간 코디 조회
- 픽토그램으로 색 중심 코디 표현
- 각 날짜의 픽토그램은 그날의 활동량에 따라 3가지 자세로 표현
- 캘린더의 각 날짜 클릭 시 코디 상세 정보 조회 가능

### 5. 설정

<img src="./assets/Settings.gif" height="500" alt="tutorial3"/><br>

- 회원정보(닉네임) 수정
- 음성 분석이 활성화 될 출퇴근 시간 수정
- 서비스 설명


# 👕기술 스택

## 기능 별 기술 스택
1. 음성 코디 입력
- 자연어 처리 : 사용자의 음성 토큰화를 통한 옷 특징 추출
- SVM(Support vector machine) 모델을 활용한 평문/의문문 구별
- Naive Bayes Classifier 모델을 활용한 사용자의 긍/부정 판단

2. 음성 화자 분석
- 인식된 음성 데이터로부터 대화하는 화자 수 추출
- MFCC : 음성 신호의 주파수 특성을 정확하게 구별해 각 화자의 특징 추출
- Pyannote : MFCC에서 추출한 정보를 활용해 효율적인 화자 분할
- 서로 보완적인 역할을 하는 두 기술을 결합


## 개발 환경

### System Architecture
<img src="./assets/System_architecture.png" alt="architecture"/>


<img src ="https://img.shields.io/badge/python-3776AB.svg?&style=for-the-badge&logo=python&logoColor=ffdd54"/> <img src ="https://img.shields.io/badge/PyTorch-EE4C2C.svg?&style=for-the-badge&logo=pytorch&logoColor=white"/> <img src ="https://img.shields.io/badge/Flask-000000.svg?&style=for-the-badge&logo=flask&logoColor=white"/> <img src ="https://img.shields.io/badge/Flutter-02569B.svg?&style=for-the-badge&logo=flutter&logoColor=white"/>
<img src="https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white"/> <img src="https://img.shields.io/badge/Spring Boot-6DB33F?style=for-the-badge&logo=Spring Boot&logoColor=white"/> <img src="https://img.shields.io/badge/Gradle-02303A?style=for-the-badge&logo=Gradle&logoColor=white"/> <img src="https://img.shields.io/badge/JSON Web Tokens-000000?style=for-the-badge&logo=JSON Web Tokens&logoColor=white"/> <img src="https://img.shields.io/badge/Spring Security-6DB33F?style=for-the-badge&logo=Spring Security&logoColor=white"/> <img src="https://img.shields.io/badge/mySql-007ec6?style=for-the-badge&logo=mySql&logoColor=white"/> <img src="https://img.shields.io/badge/Amazon EC2-569A31?style=for-the-badge&logo=Amazon EC2&logoColor=white"/> <img src="https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=Jenkins&logoColor=white"/> <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=Docker&logoColor=white"/> <img src="https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=Ubuntu&logoColor=white"/> <img src="https://img.shields.io/badge/Jira-0052CC?style=for-the-badge&logo=Jira&logoColor=white"/> <img src="https://img.shields.io/badge/GitLab-FCA121?style=for-the-badge&logo=GitLab&logoColor=white"/> <br/>

# 산출물

## 프로젝트 설계

<b>Figma</b>
<a href="https://www.figma.com/design/x5ofY06DF2N9mXaj9msi4C/%EC%84%9C%EC%9A%B8-4%EB%B0%98-9%EC%A1%B0-PJT?node-id=0-1&t=Eduh4cYxgUnjmdNU-0"><img src="./assets/figma.png" width="700" alt="figma"/></a><br>

<b>ERD</b><br>
<a href="https://www.erdcloud.com/d/6Mdr9dTKsJc6Lijvw"><img src="./assets/ERD.png" width="700" alt="ERD"/></a><br>

API 명세서

# 👕개발 멤버
<table>
    <tr>
        <td height="140px" align="center"> 
            <br> 👑 이재성<br></td>
        <td height="140px" align="center">
            <br> ⛑ 신희진<br></td>
        <td height="140px" align="center">
            <br> ⛑ 류인환<br></td>
        <td height="140px" align="center">
            <br> ⛑ 이은우<br></td>
        <td height="140px" align="center"> 
            <br> ⛑ 정진영<br></td>
        <td height="140px" align="center"> 
            <br> ⛑ 김규림<br></td>
    </tr>
    <tr>
        <td align="center">AI/ML<br>Backend</td>
        <td align="center">AI/ML<br>Frontend</td>
        <td align="center">Backend</td>
        <td align="center">Infra CI/CD<br>Backend</td>
        <td align="center">Frontend</td>
        <td align="center">Frontend</td>
    </tr>
</table>
