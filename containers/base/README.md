# Base Docker Image for Pipelines

This is a base Docker image that serves as the foundation for building other images in your project.

## Description

This Docker image is designed to provide a minimal and lightweight environment for building and running applications.
By using this base image, you can create more specialized and application-specific Docker images with ease.

## Contents

This image is based on Debian OS and include the following packages:

- cosign
- git
- git-lfs
- gnupg
- jq
- syft
- wget

Except for cosing and syft all the packages installed are the latest versions available during the image build,
for cosign and syft we pin the versions to download, but we will strive to keep them updated to the latests
versions available. But because part of the pipeline will use them we will evaluate if there are breaking changes.

This image contains also the file `/usr/local/lib/base_helpers.sh` that can be sources to enable new functions:

- `setup_gcp_access_token`: this function can be used for creating a GOOGLE_APPLICATION_CREDENTIALS file using the
	gitlab `id_tokens` functionality to allow the login via the official google cloud cli and supported libraries.
	This function expect these parameters in the following order:
	1. the path where the relevant id_token has been saved
	1. the path contained inside the GOOGLE_APPLICATION_CREDENTIALS env
	1. the google project id where the workload identity pool is localted
	1. the workload identity pool id
	1. the workload identity provider id
	1. the gcp service account email that will be impersonated

Here an example of a gitlab-ci section that use the function:

```yaml

job:
  variables:
    PROJECT_NUMBER: "000000000000"
    POOL_ID: pool_id
    PROVIDER_ID: provider_id
    GOOGLE_APPLICATION_CREDENTIALS: ${CI_BUILDS_DIR}/.workload_identity.wlconfig
    JWT_PATH: ${CI_BUILDS_DIR}/.workload_identity.jwt
    GCP_SERVICE_ACCOUNT_EMAIL: useraccount@project.iam.gserviceaccount.com
  id_tokens:
    WORKLOAD_IDENTITY_TOKEN:
      aud: https://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL_ID}/providers/${PROVIDER_ID}

  script:
  - |-
    source /usr/local/lib/base_helpers.sh
    if [[ -z ${COSIGN_PRIVATE_KEY} ]]; then
      printf "%s" "${WORKLOAD_IDENTITY_TOKEN}" > "${JWT_PATH}"
      setup_gcp_access_token "${JWT_PATH}" "${GOOGLE_APPLICATION_CREDENTIALS}" "${PROJECT_NUMBER}" "${POOL_ID}" "${PROVIDER_ID}" "${GCP_SERVICE_ACCOUNT_EMAIL}"
    fi
    do_somenthing_via_gcp_apis
```
