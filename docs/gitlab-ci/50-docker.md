# Docker

The `docker` file contains the building blocks needed for building, generating the SBOM and sign a Docker image.
The file will add a series of hidden jobs that can be extended inside the `.gitlab-ci.yml` file in the relative
project on GitLab.

The templates will ensure to build a multi-architecture image using the `IMAGE_PLATFORMS` variable for letting the
user to  add or remove platforms as they see fit.

The jobs will generate a set of env variables if not already present for permitting a full configuration of the build
process, these variables will start with the `CI_APPLICATION` prefix and are the following:

- `CI_APPLICATION_REPOSITORY`: this variables will contain the full image name, the value is dependent on if the
	GitLab Repository feature is turned on and if the `REGISTRY` environment is set
- `CI_APPLICATION_REPOSITORY_REGISTRY`: will contains the `REGISTRY` content and will be used to perform a login to
	the remote registry
- `CI_APPLICATION_REPOSITORY_USER`: is the username used during login, will contain the `REGISTRY_USER` content
- `CI_APPLICATION_REPOSITORY_PASSWORD`: is the username used during login, will contain the `REGISTRY_PASSWORD` content
- `CI_APPLICATION_TAG`: contain the tag to apply to the image, and contains by default, `latest` if the current branch
	is the `CI_DEFAULT_BRANCH`, the `CI_COMMIT_TAG` content if exists or the `CI_COMMIT_REF_SLUG` in all other cases

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
`CI_APPLICATION_TAG` variables. Additionally you can set the `DOCKERBUILD_ADDITIONAL_FLAGS` variable for add
additional flags to the command.

The `CI_COMMIT_SHA` and `CI_APPLICATION_TAG` variables will be passed respectively as the `COMMIT_SHA` and `VERSION`
build variables automatically.

The image produced by this job will use a tag that is the `CI_COMMIT_TAG` content or `CI_COMMIT_SHORT_SHA`, this
is for aiding a process of promoting images after the run of the container scanning stage.

### Usage

```yaml
docker:image:
  stage: container-build
  extends: .docker-build

  rules:
  - if: $CI_COMMIT_BRANCH
  - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    variables:
      DOCKERBUILD_OUTPUT: "type=image,push=false"
  - if: $CI_OPEN_MERGE_REQUESTS
    when: never
```

#### Jobs variables

| Key | Default Value | Description  |
| --- | --- | --- |
| DOCKERBUILD_DIR | $CI_PROJECT_DIR | the path to pass as a context to the build command |
| DOCKERFILE_PATH | $CI_PROJECT_DIR/Dockerfile | the path of the dockerfile to use |
| DOCKERBUILD_OUTPUT | type=image,push=true | the output to set for `buildx build` command, you can use this variable to change it |

#### Image

The job will use the `${CONTAINER_PATH}/docker-pipeline:${DOCKER_IMAGE_TAG}` image to run its scripts.

## .docker-deploy

This job can be used to retag images from the `CI_COMMIT_SHORT_SHA` tag to `CI_APPLICATION_TAG` if no `CI_COMMIT_TAG`
is detected or it will generate the SBOM for the current `CI_COMMIT_TAG` tag and will try to perfrom a cryptografic
signing of the image if a `COSIGN_PRIVATE_KEY_PATH` or a `SIGSTORE_ID_TOKEN` variable is found.

### Usage

```yaml
docker:deploy:
  extends: .docker-deploy
  stage: deploy

  rules:
  - if: $CI_COMMIT_BRANCH
  - if: $CI_COMMIT_TAG
```

#### Job variables

| Key | Default Value | Description  |
| --- | --- | --- |
| COSIGN_PRIVATE_KEY_PATH | "" | path to a private key for usign with cosing |
| SIGSTORE_ID_TOKEN | "" | if you are on GitLab SaaS environment, you can follow the [official guide] to setup keyless signing |

#### Image

The job will use the `${CONTAINER_PATH}/docker-pipeline:${DOCKER_IMAGE_TAG}` image to run its scripts.

[official guide]: https://docs.gitlab.com/ee/ci/yaml/signing_examples.html (GitLab documentation on keyless signing)
