# Basic replication presentation (Google slide)
- [link to the presentation](https://docs.google.com/presentation/d/1WVNzJEmeNGpoRpzuFr0Y-C-_od4R3oDrrMkifdlVNVM/edit?usp=sharing)

## To use this example
- Launch a new PowerShell terminal.
- Start SQL Server docker containers.
- CD to docker folder.
- Create a new file 'sa_password.secret' and put a strong sa's password to this file. Please make sure that you use LF line feed. 
- Run a docker-compose command with a following command.
```
    docker-compose up
```
Alternatively, if you want to force build an image, use 
```
    docker-compose up --build
```

- Wait for a while and you will have publisher,  distributor and subscriber instances.
- You can connect to each SQL Server instance with this information .
- publisher: localhost, 1433
- distributor: localhost, 1434
- subscriber: localhost, 1435

## Create a new database and setup replication 
- Launch a new PowerShell terminal.
- CD to the root of the project.
- Execute the following commmand to setup replication.
```
    .\Install-Replication.ps1
```
- After setup successfully, you will have a new database with replication.

## Testing a replication
- Run New-DatabaseRecord.ps1. It will excute stored proc to insert a new record to publisher and then select records from subscription database.
```
    .\New-DatabaseRecord.ps1
```
