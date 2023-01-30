FROM openjdk:17
COPY target/*.jar /app.jar
EXPOSE 8080
CMD java -jar /app.jar