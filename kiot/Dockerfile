# base 이미지 설정
FROM openjdk:17

# Docker 컨테이너 작업 디렉토리 설정
WORKDIR /app

# JAR_FILE 변수 정의
ARG JAR_FILE=build/libs/*.jar

# 이미지 실행 시 항상 실행되어야 하는 커맨트 설정
# 호스트 시스템의 build/libs 디렉토리에 있는 모든 jar 파일을
# Docker 컨테이너의 /app 디렉토리에 application.jar 라는 이름으로 복사
COPY ${JAR_FILE} springServer.jar

# 컨테이너가 리스닝할 포트 및 프로토콜 설정
# 지정된 포트는 해당 컨테이너 내부에서만 유효
EXPOSE 8080

# 이미지 실행시 디폴트 커맨드
# 컨테이너 시작 시 java -jar application.jar 명령 실행해 자바 어플리케이션 실행
CMD ["java", "-jar", "springServer.jar"]
