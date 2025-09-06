FROM openjdk:17-jdk-slim

WORKDIR /app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

RUN chmod +x mvnw
RUN ./mvnw clean package -DskipTests

EXPOSE 8090

ENTRYPOINT ["java", "-jar", "target/customer-0.0.1-SNAPSHOT.jar"]