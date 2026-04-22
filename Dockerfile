 # Stage 1: compilação
  FROM maven:3.9-eclipse-temurin-17 AS builder
  WORKDIR /app

  # copia o pom primeiro — se só o código mudar, o cache de dependências é reaproveitado
  COPY pom.xml .
  RUN mvn dependency:go-offline -q

  COPY src ./src
  RUN mvn package -DskipTests -q

  # Stage 2: runtime
  FROM eclipse-temurin:17-jre-alpine
  WORKDIR /app
  COPY --from=builder /app/target/*.jar app.jar
  EXPOSE 8080
  ENTRYPOINT ["java", "-jar", "app.jar"]
