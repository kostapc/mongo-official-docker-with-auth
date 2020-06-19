# mongo official docker with auth
A Docker Image for MongoDB which makes it easy to create an Admin, a Database and a Database User when the container is first launched.

# monk03/mongo-auth

```
    docker pull monk03/mongo-auth
```

# Customization
There are a number of environment variables which you can specify to customize the username and passwords of your users. 

  
- With docker-compose.yml
  ```
  services:
    db:
      image: monk03/mongo-auth
      environment:
        - AUTH=yes
        - MONGO_INITDB_ROOT_USERNAME=admin
        - MONGO_INITDB_ROOT_PASSWORD=admin123
        - MONGODB_APPLICATION_DATABASE=sample
        - MONGODB_APPLICATION_USER=aashrey
        - MONGODB_APPLICATION_PASS=admin123
      ports:
        - "27017:27017"
  // more configuration
  ```

- With command line
  ```
  docker run -it \
    -e AUTH=yes \
    -e MONGO_INITDB_ROOT_USERNAME=admin \
    -e MONGO_INITDB_ROOT_PASSWORD=adminpass \
    -e MONGODB_APPLICATION_DATABASE=mytestdatabase \
    -e MONGODB_APPLICATION_USER=testuser \
    -e MONGODB_APPLICATION_PASS=testpass \
    -p 27017:27017 monk03/mongo-auth
  ```


based on: https://github.com/aashreys/docker-mongo-auth
