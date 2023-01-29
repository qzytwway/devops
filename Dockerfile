FROM openjdk:17
ADD target/*.jar /app
CMD java -jar /app/*.jar