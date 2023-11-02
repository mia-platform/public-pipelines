# sysdig

In the sysdig file you can find jobs that will enable you to setup container scanning via the secure service of [Sysdig].

This file will import the following env variables in the global space.

| Key | Default Value | Description  |
| --- | --- | --- |
| SYSDIG_IMAGE_TAG | "1" | the tag for the sysdig image where the scripts will run |

## sysdig-container_scanning

This job will use the new container scanning cli from sysdig for creating a report of the docker image that you are
building. You will need a valid subscription with sysdig for using the container scanning functionality.

### Usage

The job is automatically added to your pipline if `CONTAINER_SCANNING_DISABLED` is not set to `1` or `true`
and you have set the `SYSDIG_SECURE_TOKEN` variable.

### Job variables

| Key | Default Value | Description  |
| --- | --- | --- |
|SYSDIG_SECURE_TOKEN | "" | the secure token from sysdig for calling their APIs |
|SYSDIG_SECURE_BACKEND_ENDPOINT | "" | the secure backend endpoint of sysdig for your tenancy |

### Image

The job will use the `${CONTAINER_PATH}/sysdig-pipeline:${SYSDIG_IMAGE_TAG}` image to run its scripts.

## sysdig-legacy-container_scanning

This job will use the legacy inline scanner of sysdig, but the rest configurations are the same of the previous jobs.
This job may be selected instead of the previous one by setting the `SYSDIG_LEGACY_SCAN` variable to `true`.

### Usage

The job is automatically added to your pipline if `CONTAINER_SCANNING_DISABLED` is not set to `1` or `true`,
you have set the `SYSDIG_SECURE_TOKEN` variable and `SYSDIG_LEGACY_SCAN` is set to `true`

### Job variables

| Key | Default Value | Description  |
| --- | --- | --- |
|SYSDIG_SECURE_TOKEN | "" | the secure token from sysdig for calling their APIs |
|SYSDIG_SECURE_BACKEND_ENDPOINT | "" | the secure backend endpoint of sysdig for your tenancy |

### Image

The job will use the `${CONTAINER_PATH}/sysdig-pipeline:${SYSDIG_IMAGE_TAG}` image to run its scripts.

[Sysdig]: https://sysdig.com (Security Tools for Containers, Kubernetes, and Cloud)
