#!/bin/bash

if  [[ ! -f .env ]] ; then
  echo "[!!] Warning: No .env file found. Please create it first, by copying .env.dist"
  exit 1
fi

source .env

if [ "$1" == "setup" ]; then
  # Make sure the MemGPT containers are stopped
  docker compose down

  # Rebuild our images
  docker compose build --pull --no-cache

  # Build the containers based on our images
  docker compose up --build -d
else
  # Just start the containers without any changes
  docker compose up -d
fi

# Bash into the memgpt container
docker exec -it memgpt /bin/bash
