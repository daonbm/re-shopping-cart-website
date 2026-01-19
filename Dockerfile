FROM eclipse-temurin:21-jdk AS build
WORKDIR /app

COPY gradlew gradlew.bat build.gradle settings.gradle /app/
COPY gradle /app/gradle

COPY src /app/src

RUN chmod +x /app/gradlew && /app/gradlew clean bootJar -x test

FROM eclipse-temurin:21-jre AS runtime
WORKDIR /app

ENV TZ=UTC
ENV JAVA_OPTS=""

COPY --from=build /app/build/libs/*.jar /app/app.jar

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]