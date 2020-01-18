#!/usr/bin/env bash

docker-compose -f docker-compose.assets.yml down && docker-compose -f docker-compose.assets.yml up -d

rm -rf docker-assets && mkdir -p docker-assets

docker cp ghost-assets:/Ghost/core/built ./docker-assets/built
docker cp ghost-assets:/Ghost/core/server/web/admin/views ./docker-assets/admin-views

docker-compose -f docker-compose.assets.yml down
