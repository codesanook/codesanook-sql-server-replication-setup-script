FROM mcr.microsoft.com/mssql/server:2017-latest

# Define the environment environment which can be accessed to all .sh files
ENV MSSQL_SA_PASSWORD=

EXPOSE 1433
COPY ./entrypoint.sh /

RUN whoami
#USER root
RUN chmod +x /entrypoint.sh
#USER mssql

RUN mkdir -p /var/opt/mssql/ReplData

ENTRYPOINT ["/entrypoint.sh"]
