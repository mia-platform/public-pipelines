# Golang

The `golang` file will provide the basic blocks for managing a **Go** project.
The file will add a series of hidden jobs that can be extended inside the `.gitlab-ci.yml` file in the relative
project on GitLab.

The templates will also try to setup useful default for the project caches and reports that can be visualized inside
GitLab. The cache is configured via the `cache.paths` property of the `.golang` job, it is configured to be equals to
the `GOPATH` property, but is not referenced directly, if you change the value of the variable you have to override
the cache configuration. The cache for go are crated inside the `.go-build` job using `go get` and then is downloaded
in all other job for later reuse.

This file will import the following env variables in the global space.

| Key | Default Value | Description |
| --- | --- | --- |
| GO_MAIN_MODULE_PATH | $CI_PROJECT_DIR | the path where the main module is found |
| GOPATH | $CI_PROJECT_DIR/.cache | the golang packages cache directory, if you change this path you must override the job cache configuration |
| GOLANG_IMAGE_TAG | 1.25 | the golang version of the image where to run the scripts, we support the latest two minor version that you can find on [go.dev site] |

## .go-build

This job is used for downloading all the dependencies of the project and try to do a full build to check if there are
no errors in the program. The download is done via calling `go get -t ./...`, with this command all the dependencies,
included the ones needed for running tests will be downloaded and refreshed in the cache.  
After the download a `go build` command is called using the `GO_MAIN_MODULE_PATH` as target for the project.

The `before_script` is left empty to allow you to set env variables, or setup access to private repositories.

### Usage

```yaml
build-app:
  stage: build
  extends: .go-build
```

### Jobs variables

| Key | Default Value | Description |
| --- | --- | --- |
| GO_CLI_OPTS | "" | optional env for passign custom configuration to the `get` and `build` command |

### Image

The job will use the `${CONTAINER_PATH}/go-pipeline:${GOLANG_IMAGE_TAG}` image to run its scripts.

## .go-lint

The `.go-lint` hidden job can be used to add a lint check of the code pushed in the repository for enforcing
company mandated style, running linter to catch common programming mistakes that render the code problematic, etc.

To do so we use the [`golangci-lint`] cli, and will we search for a configuration file present at
`GOLANG_LINT_CI_CONFIG`, if you don't have this file in your repository set the env to the **empty string** for
running the tool with the default configurations. The job is allowed to fail to avoid blocking merges for
formatting error, every developer is responsible to check if this job will report errors and to fix them appropriately.

The `before_script` is left empty to allow you to set env variables, or setup access to private repositories.

### Usage

```yaml
lint-app:
  stage: sast
  extends: .go-lint
```

### Jobs variables

| Key | Default Value | Description |
| --- | --- | --- |
| GOLANG_LINT_CI_CONFIG | "$CI_PROJECT_DIR/.golangci.yaml" | path of the `golangci-lint` configuration file |

### Image

The job will use the `${CONTAINER_PATH}/go-pipeline:${GOLANG_IMAGE_TAG}` image to run its scripts.

## .go-test

In `.go-test` you can find commands for running tests and generating a coverage file. We run the test with che
`covermode` set to `atomic` and the `race` flag enabled; you can also customize it via the `GO_CLI_OPTS` variables
for adding more flags and change the `GO_TEST_PATH` for indicating custom location for tests files.

The `before_script` is left empty to allow you to set env variables, or setup access to private repositories.

### Usage

```yaml
test:
  stage: test
  extends: .go-test
```

### Jobs variables

| Key | Default Value | Description |
| --- | --- | --- |
| GO_CLI_OPTS | "" | optional env for passign custom configuration to the test command |
| GO_TEST_PATH | "$GO_MAIN_MODULE_PATH" | you can use this variable to set a different path where to run tests |

### Image

The job will use the `${CONTAINER_PATH}/go-pipeline:${GOLANG_IMAGE_TAG}` image to run its scripts.

[go.dev site]: https://go.dev/dl/ (Golang supported versions)
[`golangci-lint`]: https://golangci-lint.run (golangci-lint is a Go linters aggregator)
