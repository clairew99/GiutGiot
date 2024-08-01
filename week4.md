# 240729 MON
1. EC2 접속 및 Spring Boot 서버 배포 테스트
2. EC2 Jenkins 설치 및 Gitlab 연결

# 240730 TUE
1. Jenkins - Gitlab 연동 및 Pipeline 작업
2. 등록 유저플로우 회의

# 240731 WED
1. Jenkins Pipeline 작업
    - [X] git clone
    - [X] build
    - [ ] deploy

# 240801 THU
1. Jenkins Pipeline 작업
- jar build 후 docker hub에 업로드 후 ec2 container에 pull 받아서 배포하는 형식으로 변경
    - [X] git clone
    - [X] back_build (jar 파일로)
    - [X] docker_build (docker 이미지로)
    - [X] docker_push (docker hub에 업로드)
    - [ ] docker_pull (docker hub -> ec2로 pull 후 배포)
