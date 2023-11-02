# Licenses

## syft-dependency-scanning

This job will add a new dependency scanning job. As the other jobs available with the SAST template, this job will
abide to the `DEPENDENCY_SCANNING_DISABLED` and `DS_EXCLUDED_ANALYZERS` env variables for allowing it in the pipeline.
The job will use syft to run a dependency scan and create a report.

If you use the ultimate subcription you can then setup the control for blocking licences that you cannot use, or
optionally you can set the `LICENSES_BLOCKLIST` env variable for failing the job if such licenses are found.

### Usage

You don't have to do anything for setting up the job in your pipeline, if you want to disable it you can set
`DEPENDENCY_SCANNING_DISABLED` to `true` or add `syft` to the list inside `DS_EXCLUDED_ANALYZERS`.

### Jobs variables

| Key | Default Value | Description  |
| --- | --- | --- |
| LICENSES_BLOCKLIST | "" | a list of valid SPDX idendifiers separated by `,` |
| SYFT_IMAGE_TAG | "1" | the tag of the image where to run the scripts |

### Image

The job will use the `${CONTAINER_PATH}/base-pipeline:${SYFT_IMAGE_TAG}` image to run its scripts.
