# Docker

In the docker file you can find the jobs that support the build and upload of docker images to a remote registry.

This file will import the following env variables in the global space.

| Key | Default Value | Description  |
| --- | --- | --- |
| REGISTRY | $CI_REGISTRY | the remote registry where to evenutally upload the image |
| IMAGE_NAME | "" | the image name to use if the remote registry is not the GitLab one |
| REGISTRY_USER | $CI_REGISTRY_USER | username of the user that will upload the image to the registry |
| REGISTRY_PASSWORD | $CI_REGISTRY_PASSWORD | password of the user that will upload the image to the registry |
| DOCKER_IMAGE_TAG | "1" | the golang version of the image where to run the scripts, we will always use the latest docker version available |
| IMAGE_PLATFORMS | linux/amd64,linux/arm64 | defualt platforms to build the image |
| ENABLE_SEMVER_TAG_WITHOUT_VERSION_PREFIX | "" | setting this variable to "1" or "true" will remove the `v` prefix from the docker tag if it is a valid semver |

## .docker-build

This job will log in to the remote registry and will run the `docker buildx build` command for building and pushing a
docker container to it. It will build the image for the platforms indicated inside the `IMAGE_PLATFORMS` env variable.  
The job will run the commands using the values inside `CI_APPLICATION_REPOSITORY_USER`,
`CI_APPLICATION_REPOSITORY_PASSWORD`, `CI_APPLICATION_REPOSITORY_REGISTRY`, `CI_APPLICATION_REPOSITORY` and
`CI_APPLICATION_TAG` variables. These variables will be automatically populated based on the base variables and the
context of the build. You can set them yourself to custom values for fully customize the build.
Additionally you can set the `DOCKERBUILD_ADDITIONAL_FLAGS` variable for add additional flags to the command.

The `CI_COMMIT_SHA` and `CI_APPLICATION_TAG` variables will be passed respectively as the `COMMIT_SHA` and `VERSION`
build variables automatically.

### Usage

#### Jobs variables

| Key | Default Value | Description  |
| --- | --- | --- |
| DOCKERBUILD_DIR | $CI_PROJECT_DIR | the path to pass as a context to the build command |
| DOCKERFILE_PATH | $CI_PROJECT_DIR/Dockerfile | the path of the dockerfile to use |

#### Image

The job will use the `${CONTAINER_PATH}/docker-pipeline:${DOCKER_IMAGE_TAG}` image to run its scripts.

## docker-push-*

These jobs will retag the image pushed during the build with a fixed tag, based on if it will run on tags or branches.
Additionally it will upload a SBOM layer for the image and it will sign image and SBOM with `cosign` when a tag is
pushed.

### Usage

The job is added automatically to the pipelines.

#### Job variables

| Key | Default Value | Description  |
| --- | --- | --- |
| COSIGN_PRIVATE_KEY | "" | path to a private key for usign with cosing |
| SIGSTORE_ID_TOKEN | "" | if you are on GitLab SaaS environment, you can follow the [official guide] to setup keyless signing |

#### Image

The job will use the `${CONTAINER_PATH}/docker-pipeline:${DOCKER_IMAGE_TAG}` image to run its scripts.

[official guide]: https://docs.gitlab.com/ee/ci/yaml/signing_examples.html (GitLab documentation on keyless signing)
