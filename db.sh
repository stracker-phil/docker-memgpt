#!/bin/bash

source .env

container="memgpt-postgres"

echo ""

if [[ -z "$(docker ps --filter name=$container --format "{{.Names}}" | grep $container)" ]]; then
    echo "To interact with the DB, please start the environment using:"
    echo "> ./start.sh"
    echo ""
    exit 1
fi

if [[ $1 == "dump" ]]; then
  dump_name=${2-memgpt}
  docker exec $container pg_dump -U $POSTGRES_USER -d $POSTGRES_DB > ./config/database/"${dump_name}.sql"

  exit_status=$?

  if [[ $exit_status -eq 0 ]]; then
    echo "✔︎ Dumped the current DB to the 'content' folder ..."
  else
    echo "✘︎ There was an error while creating the DB dump ..."
  fi
elif [[ $1 == "restore" ]]; then
  dump_name=${2-memgpt}
  cat ./config/database/"${dump_name}.sql" | docker exec -i $container psql -U $POSTGRES_USER -d $POSTGRES_DB

  exit_status=$?

  if [[ $exit_status -eq 0 ]]; then
    echo "✔︎ Restored the DB dump from the 'content' folder ..."
  else
    echo "✘︎ There was an error while restoring the DB dump ..."
  fi
else
    echo "Invalid argument. Please choose either 'dump' or 'restore'."
fi

echo ""
