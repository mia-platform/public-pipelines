# Base Docker Image for Pipelines

This is a Docker image that will be used on every pipeline job that pertain to building, promoting and signing a
Docker image.

## Description

This Docker image is designed to provide a complete package of tools for working on docker images and OCI
compliant repositories.

## Contents

This image is based on the base-pipeline image and add this components:

- docker
- buildx
- docker-compose
- a series of helper functions available on `/usr/local/lib/docker_helpers.sh`
