FROM mongo:4

RUN apt-get update && apt-get install dos2unix

ADD set_mongodb_password.sh /docker-entrypoint-initdb.d/set_mongodb_password.sh

RUN dos2unix /docker-entrypoint-initdb.d/set_mongodb_password.sh && \
    chmod +x /docker-entrypoint-initdb.d/set_mongodb_password.sh
