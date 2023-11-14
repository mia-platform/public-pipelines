# Go Docker Image for Pipelines

This is a Docker image that will be used on `go` pipelines job that pertain to building, testing and linting a golang
project.

## Description

This Docker image is designed for use it inside the `go` steps of the pipelines, and it install `go` and other major
tools for go projects.

## Contents

This image is based on the base-pipeline image and add this components:

- go
- golangci-lint
- goreleaser
- make
