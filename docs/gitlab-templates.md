# GitLab CI/CD Templates

The GitLab CI/CD templates are composed by multiple files and here we will describe their functions.

## Application.gitlab-ci.yml

The [`Application.gitlab-ci.yml`](../gitlab-ci/base/Application.gitlab-ci.yml) file is the file that will import
every other files. It will not declare any jobs, but will contains import of all the other files and the GitLab
templates that will form the base for your pipelines. This will allow you to only import this file in your
`.gitlab-ci.yaml` file inside your repository.

## Governance.gitlab-ci.yml

In the [`Governance.gitlab-ci.yml`](../gitlab-ci/base/Governance.gitlab-ci.yml`) file there will be added all the jobs
and templates that add security and compliance steps to the pipelines.  
This is a separeted file so if you are an Ultimate subscriber you can set it as a [Compliance pipelines] in your
GitLab environment groups.

The pipeline is conditionally included inside the `Application.gitlab-ci.yml` file if we detect that the Compliance
pipelines feature is turned off, so you don't have to add the file to your `.gitlab-ci.yml` file.

## SAST.gitlab-ci.yml

In the [`SAST.gitlab-ci.yml`](../gitlab-ci/base/SAST.gitlab-ci.yml`) file there are all the import for the static
security control of the pipelines. Is separated only for easier mantenability.

## Jobs

The main part of the pipelines tempaltes are implemented inside the jobs folder, inside that folder you can find
various files that create the jobs you can use to compose your pipelines.

- [docker](./jobs-templates.md#docker)
- [golang](./jobs-templates.md#golang)
- [licenses](./jobs-templates.md#licenses)
- [npm](./jobs-templates.md#npm)
- [sysdig](./jobs-templates.md#sysdig)

[Compliance pipelines]: https://docs.gitlab.com/ee/user/group/compliance_frameworks.html#compliance-pipelines
	(GitLab compliance pipelines documentation site)
