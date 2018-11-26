#!/bin/bash

echo "Building PHP-Base image..."
docker build -t giffits/php-base -f ./docker/containers/php/base/Dockerfile .

echo "Building Nginx-Base image..."
docker build -t giffits/nginx-base -f ./docker/containers/nginx/base/Dockerfile .
