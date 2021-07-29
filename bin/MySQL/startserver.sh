#!/bin/bash

# See https://dev.mysql.com/doc/refman/8.0/en/docker-mysql-getting-started.html
# for container documentation.

MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-root}
MYSQL_USER=${MYSQL_USER:-devuser}
MYSQL_PWD=${MYSQL_PWD:-devpassword}
MYSQL_DATABASE=${MYSQL_DATABASE:-clublocal}

# When the mysql-data volume does not exist, this function passes in
# environment variables that configure the root password, the dev user,
# and the dev database.
function initDatabaseVolume() {
    docker run -d --rm \
           -p 3306:3306 \
           -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
           -e MYSQL_USER=${MYSQL_USER} \
           -e MYSQL_PASSWORD=${MYSQL_PWD} \
           -e MYSQL_DATABASE=${MYSQL_DATABASE} \
           -v mysql-data:/var/lib/mysql \
           --name mysql-server-init \
           mysql/mysql-server:5.6
}

function initializeDatabase() {
    echo "Initializing database volume mysql-data..."
    containerId=$(initDatabaseVolume)
    while ! MYSQL_PWD=${MYSQL_PWD} mysql -h 127.0.0.1 -u ${MYSQL_USER} -D clublocal -e  'select 1' >/dev/null 2>&1; do
         sleep 1
    done
    echo "Initialization Complete."
    docker kill $containerId > /dev/null
}

function runDatabase() {
    docker run -d --rm \
     -p 3306:3306 \
     -v mysql-data:/var/lib/mysql \
     --name mysql-server \
     mysql/mysql-server:5.6 "$@"
}

function waitForStartup() {
    count=0
    while ! nc -z 127.0.0.1 3306 2>/dev/null; do
        sleep 1
        count=$($expr $count + 1)
        if [ $count -gt 10 ]; then
            echo "MySQL failed to start after 10 seconds." 1>&2
            exit 1
        fi
    done
    sleep 2
}

if ! docker volume ls | grep -q mysql-data; then
    initializeDatabase
fi

runDatabase
waitForStartup
