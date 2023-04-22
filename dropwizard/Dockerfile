FROM openjdk:8-jdk-alpine
LABEL AUTHOR="Jan Mangs <jmangs@gmail.com>"
COPY target/devops-service-1.0-SNAPSHOT.jar app.jar
COPY devops.yml devops.yml
EXPOSE 8080
EXPOSE 8081
ENTRYPOINT ["java","-jar","/app.jar", "server", "devops.yml"]
