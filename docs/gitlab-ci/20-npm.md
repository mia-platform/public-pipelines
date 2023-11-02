# npm

In the npm file you can find the jobs for working on a Node.js project managed by npm.
The jobs are all hidden jobs availabe/extendible via the import of the Application template.

This file will import the following env variables in the global space.

| Key | Default Value | Description  |
| --- | --- | --- |
| NPM_CLI_OPTS | "" | custom options that you can pass to the npm commands |
| NPM_CONFIG_USERCONFIG | "" | custom path to the npm user configuration, if left empty is $HOME/.npm |
| NPM_CONFIG_CACHE | $CI_PROJECT_DIR/.npm | custom path for the npm cache, if you change it you must override the job configurations to point to the new path |
| NODE_IMAGE_TAG | "18" | the node major version to use in the pipeline, our image will support the tls version that you can find at this [link] |

## .npm-build

This job will run `npm ci` and `npm rebuild` for getting the dependencies of your project based on the
`package-lock.json` and be sure to update cached built packages be compatibile with the current version of node and
of the OS. The `before_script` is left empty to allow you to set env variables, or setup access to private repositories.

### Usage

```yaml
install-app:
  stage: build
  extends: .npm-build
  variables:
    NPM_CLI_OPTS: '--ignore-scripts'
```

### Jobs variables

| Key | Default Value | Description  |
| --- | --- | --- |
| NPM_INSTALL_CLI_OPTS | "" | the `ci` command of npm support different options than the other comands you can set them here |
| NPM_CONFIG_PREFER_OFFLINE | true | control if the installation fo the module will always attempt to download them from the repository or use the version in the cache if available |
| NPM_CLI_OPTS | "" | the `rebuild` command will use this variable for additional options |

### Image

The job will use the `${CONTAINER_PATH}/node-pipeline:${NODE_IMAGE_TAG}` image to run its scripts

## .npm-test

This job will run the `coverage` script with `npm run coverage`, our marketplace items all implement this script that
will set the test framework to save and print coverage results.  
It will also set the `coverage/cobertura-coverage.xml` path as coverage report of the job, we strongly suggest to
set this script and run tests without coverage locally to save on time.

### Usage

```yaml
test-app:
  stage: test
  extends: .npm-test
```

### Job variables

| Key | Default Value | Description  |
| --- | --- | --- |
| NPM_CLI_OPTS | "" | the `run` command will use this variable for additional options |

### Image

The job will use the `${CONTAINER_PATH}/node-pipeline:${NODE_IMAGE_TAG}` image to run its scripts.

## .npm-lint

This job will run the `lint` script if available with `npm run lint --if-present`, the job is allowed to fail
to avoid blocking merges for formatting error, every developer is responsible to check if this job will report errors
and to fix them appropriately.

### Usage

```yaml
lint-app:
  stage: sast
  extends: .npm-lint
```

### Job variables

| Key | Default Value | Description  |
| --- | --- | --- |
| NPM_CLI_OPTS | "" | the `run` command will use this variable for additional options |

### Image

The job will use the `${CONTAINER_PATH}/node-pipeline:${NODE_IMAGE_TAG}` image to run its scripts.

[link]: https://github.com/nodejs/release#release-schedule (Node.js LTS release schedule)
