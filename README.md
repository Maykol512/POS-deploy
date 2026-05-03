# POS - Deploy en Railway

## Archivos incluidos
- `Dockerfile` - Configuración de Tomcat
- `POS-0_0_1-SNAPSHOT.war` - Aplicación
- `mysqldata.sql` - Base de datos

## Pasos para Railway

1. Sube este repositorio a GitHub
2. En Railway crea un nuevo proyecto → GitHub Repository
3. Agrega un servicio MySQL desde Railway
4. Configura las variables de entorno:
   - `DB_URL` = jdbc:mysql://<host>:3306/veteran?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
   - `DB_USER` = tu usuario MySQL de Railway
   - `DB_PASSWORD` = tu password MySQL de Railway
5. Importa el mysqldata.sql en la base de datos de Railway
