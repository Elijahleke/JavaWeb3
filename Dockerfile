FROM maven:3.8.4-openjdk-11-slim as build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package

FROM tomcat:9-jdk11-openjdk-slim
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/calculator.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
