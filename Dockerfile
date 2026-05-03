FROM tomcat:10.1-jdk17

# Eliminar apps por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiar el WAR
COPY POS-0_0_1-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Puerto
EXPOSE 8080

CMD ["catalina.sh", "run"]
