# Sydig Image for Pipelines

This is a Docker image that will be used on `sysdig` pipelines jobs that pertain to scanning available docker images
for security purposes.

## Description

This Docker image is designed for use it inside the `sysdig` steps of the pipelines, and it install `sysdig-cli-scanner`
and docker for working with its legacy inline scanner

## Contents

This image is based on the base-pipeline image and add this components:

- docker
- oras
- sysdig-cli-scanner
