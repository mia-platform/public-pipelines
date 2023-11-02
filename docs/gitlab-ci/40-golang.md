# Golang

In the golang file you can find the jobs for working on a Golang project. The jobs are all hidden jobs
availabe/extendible via the import of the Application template.

This file will import the following env variables in the global space.

| Key | Default Value | Description  |
| --- | --- | --- |
| GO_MAIN_MODULE_PATH | $CI_PROJECT_DIR | the path where the main module is found |
| GOPATH | $CI_PROJECT_DIR/.cache | the golang packages cache directory, if you change this path you must override the job cache configuration |
| GOLANG_IMAGE_TAG | 1.20 | the golang version of the image where to run the scripts, we support the latest two minor version that you can find on [go.dev site] |

## .go-build

This job wil run the `go build` command for building the bin of the project. You can use the `artifacts` function for
saving the generated artifacts for using them on other jobs if you need them. You can also add multiple jobs for
running different class of tests on different path if you need to.

### Usage

```yaml
build-app:
  stage: build
  extends: .go-build
  artifacts:
    paths:
    - project/bin/path
```

### Jobs variables

| Key | Default Value | Description  |
| --- | --- | --- |
| GO_CLI_OPTS | "" | optional env for passign custom configuration to the build command |

### Image

The job will use the `${CONTAINER_PATH}/go-pipeline:${GOLANG_IMAGE_TAG}` image to run its scripts.

## .go-test

This job wil run the `go test` command for running go tests.

### Usage

```yaml
test-app:
  stage: test
  extends: .go-test
```

### Jobs variables

| Key | Default Value | Description  |
| --- | --- | --- |
| GO_TEST_CLI_OPTS | "" | optional env for passign custom configuration to the test command |
| GO_TEST_PATH | "$GO_MAIN_MODULE_PATH" | you can use this variable to set a different path where to run tests |

### Image

The job will use the `${CONTAINER_PATH}/go-pipeline:${GOLANG_IMAGE_TAG}` image to run its scripts.

## .go-lint

This job wil run the `golangci-lint` tool for applying lint rules to your code. The job is allowed to fail
to avoid blocking merges for formatting error, every developer is responsible to check if this job will report errors
and to fix them appropriately.

### Usage

```yaml
lint-app:
  stage: sast
  extends: .go-lint
```

### Jobs variables

| Key | Default Value | Description  |
| --- | --- | --- |
| GOLANG_LINT_CI_CONFIG | "$CI_PROJECT_DIR/.golangci.yaml" | path of the `golangci-lint` configuration file |

### Image

The job will use the `${CONTAINER_PATH}/go-pipeline:${GOLANG_IMAGE_TAG}` image to run its scripts.

[go.dev site]: https://go.dev/dl/ (Golang supported versions)
