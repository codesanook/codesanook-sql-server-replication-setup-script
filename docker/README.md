### Build image
docker-compose build

### Start SQL Server
docker-compose up

### Where is Settings.txt
/App_Data/Sites/Default/Settings.txt

### Copy a file to a container 
docker cp db.bacpac docker_db_1:var/opt/mssql/data/

### Prevent auto crlf 
git config --global core.autocrlf false

### Your SQL Sever is very slow or cannot create all instances
For docker compose multiple instances, you need to add ram from 2 GB to 6 GB
each SQL Server instance can consume to 2 GB