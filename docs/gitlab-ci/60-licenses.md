# Licenses

The `licenses` file contains an additional SAST job that introduce a dependency scanner based on syft that can be
used as an alternative to the one implementend in the Ultimate offering of GitLab.
This job will not integrate with the GitLab flow for managing and reviewing dependencies inside the GitLab UI, but
you can use the `LICENSES_BLOCKLIST` env variable for explicity block licences that your project cannot import.

We reccomend to turn off this scanner if you are paying for the Ultimate subscription, for its better integration
with the GitLab UI and flow.

## syft-dependency_scanning

The job will run syft for generating a SBOM report in **SPDX** and **CycloneDX** format. The cdx format is passed as
an artifact report for the job.

After the report generation it will use `jq` for parsing the SPDX one and try to find any licence listed inside
the `LICENSES_BLOCKLIST` variable. If the variable is empty no control will be performed.

The job will pickup any change made in the `.ds-analyzer` hidden job, and will follow the same rule for
`DEPENDENCY_SCANNING_DISABLED` and `DS_EXCLUDED_ANALYZERS` variables that the official GitLab guide is reccomending.

### Usage

You don't have to do anything for setting up the job in your pipeline, if you want to disable it you can set
`DEPENDENCY_SCANNING_DISABLED` to `true` or add `syft` to the list in `DS_EXCLUDED_ANALYZERS`.

### Jobs variables

| Key | Default Value | Description  |
| --- | --- | --- |
| LICENSES_BLOCKLIST | "" | a list of valid SPDX idendifiers separated by `,` do not add any blank space in the list |
| SYFT_IMAGE_TAG | "1" | the tag of the image where to run the scripts |

### Image

The job will use the `${CONTAINER_PATH}/base-pipeline:${SYFT_IMAGE_TAG}` image to run its scripts.
