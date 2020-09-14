#!/bin/bash

# Intercept set SA_PASSWORD environment variable from Docker secret MSSQL_SA_PASSWORD_FILE)
# https://stackoverflow.com/a/13864829/1872200
if [ ! -z ${MSSQL_SA_PASSWORD_FILE} ]
then
    MSSQL_SA_PASSWORD=$(cat $MSSQL_SA_PASSWORD_FILE)
fi

echo  "MSSQL_SA_PASSWORD '$MSSQL_SA_PASSWORD'"
/opt/mssql/bin/sqlservr
