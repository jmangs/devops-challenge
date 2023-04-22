FROM openjdk:8-jdk-alpine
LABEL AUTHOR="Jan Mangs <jmangs@gmail.com>"
COPY target/devops-service-1.0-SNAPSHOT.jar app.jar
COPY devops.yml devops.yml
ENTRYPOINT ["java","-jar","/app.jar", "server", "devops.yml"]
