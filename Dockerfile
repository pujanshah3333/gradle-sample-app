FROM gradle:5.4.1-jdk8-alpine@sha256:1cb081cfa6d25d718f6276c3df6474b332c06278d8bb64bcb0fc1243b1e4491e AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle build --no-daemon 

FROM openjdk:11-jre-slim@sha256:c653b8f18b8f3e9e5b801b72eba306c2574a8e3f499be4ac9315caeb3628e7d2

EXPOSE 8080

RUN mkdir /app

COPY --from=build /home/gradle/src/build/libs/*.jar /app/spring-boot-application.jar

ENTRYPOINT ["java", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-Djava.security.egd=file:/dev/./urandom","-jar","/app/spring-boot-application.jar"]

