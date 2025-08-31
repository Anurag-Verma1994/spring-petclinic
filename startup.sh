#!/bin/sh

# Create directories for properties files
mkdir -p /run/secrets/db-username
mkdir -p /run/secrets/db-password
mkdir -p /run/secrets/db-connection

# Create properties files from mounted secrets
echo "POSTGRES_USER=$(cat /run/secrets/db-username)" > /run/secrets/db-username/username.properties
echo "POSTGRES_PASS=$(cat /run/secrets/db-password)" > /run/secrets/db-password/password.properties

# Parse connection JSON and create properties
CONNECTION=$(cat /run/secrets/db-connection)
echo "POSTGRES_HOST=$(echo $CONNECTION | jq -r .host)" > /run/secrets/db-connection/connection.properties
echo "POSTGRES_PORT=$(echo $CONNECTION | jq -r .port)" >> /run/secrets/db-connection/connection.properties
echo "POSTGRES_DB=$(echo $CONNECTION | jq -r .database)" >> /run/secrets/db-connection/connection.properties

# Start the application
exec java -jar /app.jar
