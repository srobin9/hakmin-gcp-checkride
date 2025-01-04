FROM tomcat:9.0-jdk11-openjdk

# PostgreSQL JDBC 드라이버 다운로드 및 복사
RUN wget -O /usr/local/tomcat/lib/postgresql-42.6.0.jar https://jdbc.postgresql.org/download/postgresql-42.6.0.jar
RUN apt-get update -y
RUN apt-get install -y curl

# index.html 파일 추가
#COPY index.html /tmp/index.html

# dbcheck.jsp 파일 추가
#COPY dbcheck.jsp /tmp/dbcheck.jsp