# Yarn

The `yarn` file will provide you with basic blocks for managing a **Node.js** project managed by `Yarn`.
The file will add a series of hidden jobs that you can then be extended inside the `.gitlab-ci.yml` file in the
relative project on GitLab.

Inside the provided image, the latest version of Yarn is installed but we reccomend to use the preferred workflow of
Yarn and set the version you want to use with `yarn set version <yarn-version>`. This command will set the appropriate
configuration inside the `package.json` and `.yarnrc.yml` files.

The templates will also try to setup useful default for the project caches and reports that can be visualized inside
GitLab. The cache is composed by two different blocks; the first one that is used only on the `.yarn-build` job is aimed
to speed up the `yarn install` command and is the yarn cache for already downloaded packages. The second one is then
used inside the other jobs and by default contains only the `node_modules` folders available inside the project.  
If you have to add more paths, or prefer to use the pnp linker, you cna override the `cache.paths` property of the
`.yarn` job and it will be set for every other job.

This file will set the following env variables in the global space.

| Key | Default Value | Description  |
| --- | --- | --- |
| NPM_CONFIG_USERCONFIG | "" | custom path to the npm user configuration, if left empty is $HOME/.npm, it can be used with yarn classic compatibility mode |
| YARN_CACHE_FOLDER | $CI_PROJECT_DIR/.yarn/cache | custom path for the yarn cache, if you change it you must override the `.yarn-build` job cache configurations to point to the new path, we higly discourage that |
| NODE_IMAGE_TAG | "20" | the node major version to use in the pipeline, our image will support the tls version that you can find at this [link] |

## .yarn-build

This job is used for setting up the repository for the subsequent stages of the pipeline, is responsible to download
the project dependencies, refresh the ones that are dependent on the operating system or Node.js version and to
build/transpile the source files if needed.  
To do this the job will run the `install` and `run build` command of `yarn`. The last one is run only if found inside
the `package.json` file because not every project need to be built, if your project must be built, we reccomend to
add the relevant folders created by the process to the cache for being available to other yarn related jobs and/or to an
artifact if they must be availabe to other jobs in the pipeline.

We use the `YARNPKG_INSTALL_CLI_OPTS` env variable to set specific flags for the `install` command and the
`YARNPKG_CLI_OPTS` one for `run build`.

The `before_script` is left empty to allow you to set env variables, or setup access to private repositories, even if
if possible we reccomend to configure yarn via its env variables that use the `YARN_` prefix or the two previously
mentioned variables for setting up additional flags.

### Usage Example

```yaml
install-app:
  stage: build
  extends: .yarn-build
```

### Jobs variables

| Key | Default Value | Description  |
| --- | --- | --- |
| YARNPKG_INSTALL_CLI_OPTS | "" | the `install` command of yarn support different options than the other comands you can set them here |
| YARNPKG_CLI_OPTS | "" | the `run build` command will use this variable for additional options |

### Image

The job will use the `${CONTAINER_PATH}/node-pipeline:${NODE_IMAGE_TAG}` image to run its scripts.

## .yarn-lint

The `.yarn-lint` hidden job can be used to add a lint check of the code pushed on the repository for enforcing
company mandated style, running linter to catch common programming mistakes that render the code problematic, etc.

To do so we try to run a script called `lint`, in this script you can run your preferred tool like `ESLint`,
`JSHint`, `Prettier` and/or any other program you want to use.

As this can be seen as a SAST job we are configuring it as allowed to fail to avoid to block the pipeline if the
command is missing, missconfigured or if found issues that can be resolved in subsequent commits. For this reason we
also set the default rule of the job to run only on branches and on merge request pipelines and avoid to run it on
tags.

The `before_script` is left empty to allow you to set env variables, or setup access to private repositories, even if
if possible we reccomend to configure yarn via its env variables that use the `YARN_` prefix or `YARNPKG_CLI_OPTS` for
setting up additional flags.

### Usage

```yaml
lint-app:
  stage: sast
  extends: .yarn-lint
```

### Job variables

| Key | Default Value | Description  |
| --- | --- | --- |
| YARNPKG_CLI_OPTS | "" | the `run lint` command will use this variable for additional options |

### Image

The job will use the `${CONTAINER_PATH}/node-pipeline:${NODE_IMAGE_TAG}` image to run its scripts.

## .yarn-test

In `.yarn-test` we try to run the `coverage` script of your `package.json`. In this script we expect that you will run
your test framework with a coverage package enabled for creating a report in the cobertura standard and if possibile
a junit report. This files will be picked up via the relative reporters for GitLab to process and we will try to find
possible coverage file names `cobertura-coverage.xml` and junit report called `junit.xml` in every subfolders of the
project.

The `before_script` is left empty to allow you to set env variables, or setup access to private repositories, even if
if possible we reccomend to configure yarn via its env variables that use the `YARN_` prefix or `YARNPKG_CLI_OPTS` for
setting up additional flags.

### Usage

```yaml
test-app:
  stage: test
  extends: .yarn-test
```

### Job variables

| Key | Default Value | Description  |
| --- | --- | --- |
| YARNPKG_CLI_OPTS | "" | the `run coverage` command will use this variable for additional options |

### Image

The job will use the `${CONTAINER_PATH}/node-pipeline:${NODE_IMAGE_TAG}` image to run its scripts.

## .yarn-publish

The last job we provide is `.yarn-publish` and its variant if you still use yarn v1 `.yarn-classi-publish` and as
its name suggest, is a job you can use for publishing your package to a remote index, like npm.js or an internal
one used by your organization like JFrog Artifactory.

The command that is invoked is `yarn npm publish`, or `yarn publish` for the classic variant, and you can personalized
it using the `YARNPKG_CLI_OPTS` or via configuring yarn via the `YARN_` variables.

Remember to setup a rules that is conformant with your organization policies for uploading the package, like running
the job on tags and/or via manual approval.

### Usage

```yaml
publish-package:
  stage: deploy
  extends: .yarn-publish

  rules:
  - if: $CI_COMMIT_TAG
```

### Job variables

| Key | Default Value | Description  |
| --- | --- | --- |
| YARNPKG_CLI_OPTS | "" | the `npm publish` command will use this variable for additional options |

### Image

The job will use the `${CONTAINER_PATH}/node-pipeline:${NODE_IMAGE_TAG}` image to run its scripts.

[link]: https://github.com/nodejs/release#release-schedule (Node.js LTS release schedule)
