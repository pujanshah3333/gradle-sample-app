FROM gradle:4.7.0-jdk8-alpine@sha256:588dcfb0c01babf0ed3989462f13600567e8c5325ea746122dea10717d0a7676 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle build --no-daemon 

FROM openjdk:8-jre-slim@sha256:43215739395627f798132b2626a315956d28985bd66f73048aa58736374e35c5

EXPOSE 8080

RUN mkdir /app

COPY --from=build /home/gradle/src/build/libs/*.jar /app/spring-boot-application.jar

ENTRYPOINT ["java", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-Djava.security.egd=file:/dev/./urandom","-jar","/app/spring-boot-application.jar"]

