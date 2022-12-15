FROM maven:3.6.0-jdk-11-slim AS builder
COPY ./CurrentAccount.yaml ./CurrentAccount.yaml
RUN curl https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/6.2.1/openapi-generator-cli-6.2.1.jar -o openapi-generator-cli.jar
RUN java -jar ./openapi-generator-cli.jar generate -i ./CurrentAccount.yaml -g spring -o /codebase
RUN mvn -f /codebase/pom.xml clean install
 
FROM eclipse-temurin:17-jre-jammy
WORKDIR /opt/app
EXPOSE 8080
COPY --from=builder /codebase/target/*.jar /opt/app/*.jar
ENTRYPOINT ["java", "-jar", "/opt/app/*.jar" ]