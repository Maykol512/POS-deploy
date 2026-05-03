FROM tomcat:10.1-jdk17

# Eliminar apps por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiar el WAR
COPY app.war /usr/local/tomcat/webapps/ROOT.war

# Puerto
EXPOSE 8080

CMD ["catalina.sh", "run"]
