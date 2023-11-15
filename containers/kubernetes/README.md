# Kuberentes Image for Pipelines

This is a Docker image that will be used on `kubernetes deploy` pipelines jobs.

## Description

This Docker image is designed for use it inside the `kubernetes deploy` steps of the pipelines, and it install
a series of tool that can be used for deploying a series of yaml files to a Kuberentes cluster.

## Contents

This image is based on the base-pipeline image and add this components:

- kubectl
- mlp
- helm
