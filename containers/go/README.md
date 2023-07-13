# Go Docker Image

This is Docker image is used for the `go` pipelines.

## Description

This Docker image is designed for use it inside the `go` steps of the pipelines, and it install `go` and
its major used package managers.

## Contents

This image is based on the build-base image and add this components:

- go 1.20.5
- golangci-lint v1.53.3
- goreleaser
- make
