# GitLab CI/CD Templates

The GitLab CI/CD templates are composed by multiple files and here you can find a brief overview of what
they contains, and how, the various jobs that they will add, works and can be customized.

## Main Files

### Application.gitlab-ci.yml

The `Application.gitlab-ci.yml` file is the file that will import
every other files. It will not declare any jobs, but will contain imports of all the other files and the GitLab
templates that will form the base for your pipelines. This will allow you to only import this file in your
`.gitlab-ci.yaml` file inside your repository.

### Governance.gitlab-ci.yml

In the `Governance.gitlab-ci.yml` file there will be added all the jobs
and templates that add security and compliance steps to the pipelines.  
This is a separeted file so if you are an Ultimate subscriber you can set it as a [Compliance pipelines] in your
GitLab environment groups.

The pipeline is conditionally included inside the `Application.gitlab-ci.yml` file if we detect that the Compliance
pipelines feature is turned off.

Once set to be enforced at the Group and Project level. This file will be the file GitLab CI processes and runs first.
Everything set and defined in this file will be immutable and unable to be changed or overwritten by the development
teams. This file will invoke the `.gitlab-ci.yml`` file in a team's repository; there the team can define any number
of jobs or variables. However, what's defined in this file will take precedent over anything defined in the
individual projects.

In this file will also explicited the standard stages for the pipelines:

- `build`
- `sast`
- `test`
- `container-build`
- `compliance`
- `deploy`

### GovernanceOverrides.gitlab-ci.yml

In the `GovernanceOverrides.gitlab-ci.yml`file there will be added overrides for the security steps included inside
the Governance file.

### CustomOverrides.gitlab-ci.yml

In the `CustomOverrides.gitlab-ci.yml` file the maintainers of the templates for your organization can add all the
overrides needed by them to conform the pipeline templates to their GitLab environment.  
We reccomend to use only this file to ad your overrides to simplify eventual upgrades of the templates after the
first installation.

## Jobs Folder

The main part of the pipeline templates are implemented inside the `jobs` folder, inside that folder you can find
various files that create the jobs you can use to compose your pipelines.

- [npm](./20-npm.md)
- [yarn](./30-yarn.md)
- [golang](./40-golang.md)
- [docker](./50-docker.md)
- [licenses](./60-licenses.md)
- [sysdig](./70-sysdig.md)

[Compliance pipelines]: https://docs.gitlab.com/ee/user/group/compliance_frameworks.html#compliance-pipelines
	(GitLab compliance pipelines documentation site)
