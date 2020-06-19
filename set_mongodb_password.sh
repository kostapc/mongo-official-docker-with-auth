#!/bin/bash

if [ -z $MONGO_INITDB_ROOT_USERNAME ] || [ -z $MONGO_INITDB_ROOT_PASSWORD ] ; then
  echo "WARN! root user or password not set, but required for enable auth"
fi

# Application Database User
MONGO_APPLICATION_DATABASE=${MONGO_APPLICATION_DATABASE:-"test"}
MONGO_APPLICATION_USER=${MONGO_APPLICATION_USER:-"test"}
MONGO_APPLICATION_PASS=${MONGO_APPLICATION_PASS:-"test"}

# Wait for MongoDB to boot
RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service startup..."
    sleep 5
    mongo admin --eval "help" >/dev/null 2>&1
    RET=$?
done

sleep 3

# If we've defined the MONGO_APPLICATION_DATABASE environment variable and it's a different database
# than admin, then create the user for that database.
# First it authenticates to Mongo using the admin user it created above.
# Then it switches to the REST API database and runs the createUser command 
# to actually create the user and assign it to the database.
if [ "$MONGO_APPLICATION_DATABASE" != "admin" ] && [ ! -f /data/db/.mongodb_password_set ]; then
    echo "=> Creating a ${MONGO_APPLICATION_DATABASE} database user with a password in MongoDB"
    mongo admin -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD << EOF
echo "Using $MONGO_APPLICATION_DATABASE database"
use $MONGO_APPLICATION_DATABASE
db.createUser({user: '$MONGO_APPLICATION_USER', pwd: '$MONGO_APPLICATION_PASS', roles:[{role:'dbOwner', db:'$MONGO_APPLICATION_DATABASE'}]})
EOF
fi

sleep 1

# If everything went well, add a file as a flag so we know in the future to not re-create the
# users if we're recreating the container (provided we're using some persistent storage)
touch /data/db/.mongodb_password_set

echo "MongoDB configured successfully. You may now connect to the DB."