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
- oras
- syft
- wget
- yq

Except for cosing and syft all the packages installed are the latest versions available during the image build,
for cosign and syft we pin the versions to download, but we will strive to keep them updated to the latests
versions available. But because part of the pipeline will use them we will evaluate if there are breaking changes.

This image contains also the file `/usr/local/lib/base_helpers.sh` that can be sources to enable new functions:

- `setup_gcp_access_token`: this function can be used for creating a GOOGLE_APPLICATION_CREDENTIALS file using the
  gitlab `id_tokens` functionality to allow the login via the official google cloud cli and supported libraries.
  This function expect these parameters in the following order:

  1. the gitlab jwt token created with `id_tokens` directive
  1. the workload identity federation provider url
  1. the gcp service account email that will be impersonated
  1. the output directory path where the script will save the generated files

  It will return the path where the GOOGLE_APPLICATION_CREDENTIALS has been saved, you can set it to the correct
  environment variables and export it to use it inside other functions.  
  Here an example of a gitlab-ci section that use the function:

  ```yaml
  job:
    variables:
      GCP_AUDIENCE: //iam.googleapis.com/projects/000000000000/locations/global/workloadIdentityPools/pool_id/providers/provider_id
      GCP_SERVICE_ACCOUNT_EMAIL: useraccount@project.iam.gserviceaccount.com
      CREDENTIALS_PATH: ${CI_BUILDS_DIR}/.google_config
    id_tokens:
      WORKLOAD_IDENTITY_TOKEN:
        aud: https://example.com/your/audience

    script:
    - source /usr/local/lib/base_helpers.sh
    - mkdir -p "${CREDENTIALS_PATH}"
    - GOOGLE_APPLICATION_CREDENTIALS="$(setup_gcp_access_token "${WORKLOAD_IDENTITY_TOKEN}" "${GCP_AUDIENCE}" "${GCP_SERVICE_ACCOUNT_EMAIL}" "{CREDENTIALS_PATH}")"
  	- export GOOGLE_APPLICATION_CREDENTIALS
    - do_somenthing_via_gcp_apis

    after_script:
      rm -fr "${CREDENTIALS_PATH}"
  ```
