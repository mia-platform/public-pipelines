# Sysdig

The `sysdig` file will add the capability to use the secure service of [Sysdig] for scan the docker images built for
vulnerabilities. The file is supporting both scanning engine, the legacy one and the new one via two different
jobs, by default the new engine is used via the new `sysdig-cli-scanner` cli but you can opt in to use the legacy one
setting the `SYSDIG_LEGACY_SCAN` to **1** or **true**.

As with the default GitLab container scanner the jobs can be turned off setting the variable `CONTAINER_SCANNING_DISABLED`
to **1** or **true**.

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
