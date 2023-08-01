# Jobs

Here you can find all the jobs that are defined inside the jobs folder and the various configuration on which
you can customize them.

## Docker

In the docker file you can find the jobs that support the build and upload of docker images to a remote registry.

This file will import the following env variables in the global space.

| Key | Default Value | Description  |
| --- | --- | --- |
| REGISTRY | $CI_REGISTRY | the remote registry where to evenutally upload the image |
| REGISTRY_USER | $CI_REGISTRY_USER | username of the user that will upload the image to the registry |
| REGISTRY_PASSWORD | $CI_REGISTRY_PASSWORD | password of the user that will upload the image to the registry |
| IMAGE_NAME | "" | the image name to use if the remote registry is not the GitLab one |
| IMAGE_PLATFORMS | linux/amd64,linux/arm64 | defualt platforms to build the image |
| DOCKER_IMAGE_TAG | "1" | the golang version of the image where to run the scripts, we will always use the latest docker version available |
| ENABLE_DOCKER_BUILD_IN_MR | "true" | if left to true during MR pipelines we try to build the docker containers withotu pushing it to the remote repository |

### docker-build

This job wil run the `docker buildx build` command for building a docker image. The job will run automatically
if a `Dockerfile` is found inside the repository.

#### Usage

The job is added automatically to the pipelines.

#### Jobs variables

| Key | Default Value | Description  |
| --- | --- | --- |
| DOCKERBUILD_DIR | $CI_PROJECT_DIR | the path to pass as a context to the build command |
| DOCKERFILE_PATH | $CI_PROJECT_DIR/Dockerfile | the path of the dockerfile to use |

#### Image

The job will use the `${CONTAINER_PATH}/docker-pipeline:${DOCKER_IMAGE_TAG}` image to run its scripts.

### docker-push-*

These jobs will retag the image pushed during the build with a fixed tag, based on if it will run on tags or branches.
Additionally it will upload a SBOM layer for the image and it will sign image and SBOM with `cosign` when a tag is
pushed.

#### Usage

The job is added automatically to the pipelines.

#### Job variables

| Key | Default Value | Description  |
| --- | --- | --- |
| COSIGN_PRIVATE_KEY | "" | path to a private key for usign with cosing |
| SIGSTORE_ID_TOKEN | "" | if you are on GitLab SaaS environment, you can follow the [official guide] to setup keyless signing |

#### Image

The job will use the `${CONTAINER_PATH}/docker-pipeline:${DOCKER_IMAGE_TAG}` image to run its scripts.

## Golang

In the golang file you can find the jobs for working on a Golang project. The jobs are all hidden jobs
availabe/extendible via the import of the Application template.

This file will import the following env variables in the global space.

| Key | Default Value | Description  |
| --- | --- | --- |
| GO_MAIN_MODULE_PATH | $CI_PROJECT_DIR | the path where the main module is found |
| GOPATH | $CI_PROJECT_DIR/.cache | the golang packages cache directory, if you change this path you must override the job cache configuration |
| GOLANG_IMAGE_TAG | 1.20 | the golang version of the image where to run the scripts, we support the latest two minor version that you can find on [go.dev site] |

### .go-build

This job wil run the `go build` command for building the bin of the project. You can use the `artifacts` function for
saving the generated artifacts for using them on other jobs if you need them. You can also add multiple jobs for
running different class of tests on different path if you need to.

#### Usage

```yaml
build-app:
  stage: build
  extends: .go-build
  artifacts:
    paths:
    - project/bin/path
```

#### Jobs variables

| Key | Default Value | Description  |
| --- | --- | --- |
| GO_CLI_OPTS | "" | optional env for passign custom configuration to the build command |

#### Image

The job will use the `${CONTAINER_PATH}/go-pipeline:${GOLANG_IMAGE_TAG}` image to run its scripts.

### .go-test

This job wil run the `go test` command for running go tests.

#### Usage

```yaml
test-app:
  stage: test
  extends: .go-test
```

#### Jobs variables

| Key | Default Value | Description  |
| --- | --- | --- |
| GO_TEST_CLI_OPTS | "" | optional env for passign custom configuration to the test command |
| GO_TEST_PATH | "$GO_MAIN_MODULE_PATH" | you can use this variable to set a different path where to run tests |

#### Image

The job will use the `${CONTAINER_PATH}/go-pipeline:${GOLANG_IMAGE_TAG}` image to run its scripts.

### .go-lint

This job wil run the `golangci-lint` tool for applying lint rules to your code. The job is allowed to fail
to avoid blocking merges for formatting error, every developer is responsible to check if this job will report errors
and to fix them appropriately.

#### Usage

```yaml
lint-app:
  stage: sast
  extends: .go-lint
```

#### Jobs variables

| Key | Default Value | Description  |
| --- | --- | --- |
| GOLANG_LINT_CI_CONFIG | "$CI_PROJECT_DIR/.golangci.yaml" | path of the `golangci-lint` configuration file |

#### Image

The job will use the `${CONTAINER_PATH}/go-pipeline:${GOLANG_IMAGE_TAG}` image to run its scripts.

## Lincenses

### syft-dependency-scanning

This job will add a new dependency scanning job. As the other jobs available with the SAST template, this job will
abide to the `DEPENDENCY_SCANNING_DISABLED` and `DS_EXCLUDED_ANALYZERS` env variables for allowing it in the pipeline.
The job will use syft to run a dependency scan and create a report.

If you use the ultimate subcription you can then setup the control for blocking licences that you cannot use, or
optionally you can set the `LICENSES_BLOCKLIST` env variable for failing the job if such licenses are found.

#### Usage

You don't have to do anything for setting up the job in your pipeline, if you want to disable it you can set
`DEPENDENCY_SCANNING_DISABLED` to `true` or add `syft` to the list inside `DS_EXCLUDED_ANALYZERS`.

#### Jobs variables

| Key | Default Value | Description  |
| --- | --- | --- |
| LICENSES_BLOCKLIST | "" | a list of valid SPDX idendifiers separated by `,` |
| SYFT_IMAGE_TAG | "1" | the tag of the image where to run the scripts |

#### Image

The job will use the `${CONTAINER_PATH}/base-pipeline:${SYFT_IMAGE_TAG}` image to run its scripts.

## npm

In the npm file you can find the jobs for working on a Node.js project managed by npm.
The jobs are all hidden jobs availabe/extendible via the import of the Application template.

This file will import the following env variables in the global space.

| Key | Default Value | Description  |
| --- | --- | --- |
| NPM_CLI_OPTS | "" | custom options that you can pass to the npm commands |
| NPM_CONFIG_USERCONFIG | "" | custom path to the npm user configuration, if left empty is $HOME/.npm |
| NPM_CONFIG_CACHE | $CI_PROJECT_DIR/.npm | custom path for the npm cache, if you change it you must override the job configurations to point to the new path |
| NODE_IMAGE_TAG | "18" | the node major version to use in the pipeline, our image will support the tls version that you can find at this [link] |

### .npm-build

This job will run `npm ci` and `npm rebuild` for getting the dependencies of your project based on the
`package-lock.json` and be sure to update cached built packages be compatibile with the current version of node and
of the OS. The `before_script` is left empty to allow you to set env variables, or setup access to private repositories.

#### Usage

```yaml
install-app:
  stage: build
  extends: .npm-build
  variables:
    NPM_CLI_OPTS: '--ignore-scripts'
```

#### Jobs variables

| Key | Default Value | Description  |
| --- | --- | --- |
| NPM_INSTALL_CLI_OPTS | "" | the `ci` command of npm support different options than the other comands you can set them here |
| NPM_CONFIG_PREFER_OFFLINE | true | control if the installation fo the module will always attempt to download them from the repository or use the version in the cache if available |
| NPM_CLI_OPTS | "" | the `rebuild` command will use this variable for additional options |

#### Image

The job will use the `${CONTAINER_PATH}/node-pipeline:${NODE_IMAGE_TAG}` image to run its scripts

### .npm-test

This job will run the `coverage` script with `npm run coverage`, our marketplace items all implement this script that
will set the test framework to save and print coverage results.  
It will also set the `coverage/cobertura-coverage.xml` path as coverage report of the job, we strongly suggest to
set this script and run tests without coverage locally to save on time.

#### Usage

```yaml
test-app:
  stage: test
  extends: .npm-test
```

#### Job variables

| Key | Default Value | Description  |
| --- | --- | --- |
| NPM_CLI_OPTS | "" | the `run` command will use this variable for additional options |

#### Image

The job will use the `${CONTAINER_PATH}/node-pipeline:${NODE_IMAGE_TAG}` image to run its scripts.

### .npm-lint

This job will run the `lint` script if available with `npm run lint --if-present`, the job is allowed to fail
to avoid blocking merges for formatting error, every developer is responsible to check if this job will report errors
and to fix them appropriately.

#### Usage

```yaml
lint-app:
  stage: sast
  extends: .npm-lint
```

#### Job variables

| Key | Default Value | Description  |
| --- | --- | --- |
| NPM_CLI_OPTS | "" | the `run` command will use this variable for additional options |

#### Image

The job will use the `${CONTAINER_PATH}/node-pipeline:${NODE_IMAGE_TAG}` image to run its scripts.

## sysdig

In the sysdig file you can find jobs that will enable you to setup container scanning via the secure service of [Sysdig].

This file will import the following env variables in the global space.

| Key | Default Value | Description  |
| --- | --- | --- |
| SYSDIG_IMAGE_TAG | "1" | the tag for the sysdig image where the scripts will run |

### sysdig-container_scanning

This job will use the new container scanning cli from sysdig for creating a report of the docker image that you are
building. You will need a valid subscription with sysdig for using the container scanning functionality.

#### Usage

The job is automatically added to your pipline if `CONTAINER_SCANNING_DISABLED` is not set to `1` or `true`
and you have set the `SYSDIG_SECURE_TOKEN` variable.

#### Job variables

| Key | Default Value | Description  |
| --- | --- | --- |
|SYSDIG_SECURE_TOKEN | "" | the secure token from sysdig for calling their APIs |
|SYSDIG_SECURE_BACKEND_ENDPOINT | "" | the secure backend endpoint of sysdig for your tenancy |

#### Image

The job will use the `${CONTAINER_PATH}/sysdig-pipeline:${SYSDIG_IMAGE_TAG}` image to run its scripts.

### sysdig-legacy-container_scanning

This job will use the legacy inline scanner of sysdig, but the rest configurations are the same of the previous jobs.
This job may be selected instead of the previous one by setting the `SYSDIG_LEGACY_SCAN` variable to `true`.

#### Usage

The job is automatically added to your pipline if `CONTAINER_SCANNING_DISABLED` is not set to `1` or `true`,
you have set the `SYSDIG_SECURE_TOKEN` variable and `SYSDIG_LEGACY_SCAN` is set to `true`

#### Job variables

| Key | Default Value | Description  |
| --- | --- | --- |
|SYSDIG_SECURE_TOKEN | "" | the secure token from sysdig for calling their APIs |
|SYSDIG_SECURE_BACKEND_ENDPOINT | "" | the secure backend endpoint of sysdig for your tenancy |

#### Image

The job will use the `${CONTAINER_PATH}/sysdig-pipeline:${SYSDIG_IMAGE_TAG}` image to run its scripts.

[official guide]: https://docs.gitlab.com/ee/ci/yaml/signing_examples.html (GitLab documentation on keyless signing)
[go.dev site]: https://go.dev/dl/ (Golang supported versions)
[link]: https://github.com/nodejs/release#release-schedule (Node.js LTS release schedule)
[Sysdig]: https://sysdig.com (Security Tools for Containers, Kubernetes, and Cloud)
