#!/bin/bash
docker-compose down --volumes
docker-compose up --build -d
docker exec -it i1  bash
