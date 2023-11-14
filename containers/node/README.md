# Node Docker Image for Pipelines

This is a Docker image that will be used on `npm` and `yarn` pipelines jobs that pertain to building, testing and
linting a nodejs project with its main package managers.

## Description

This Docker image is designed for use it inside the `npm` and `yarn` steps of the pipelines, and it install `nodejs`
and its major package managers.

## Contents

This image is based on the base-pipeline image and add this components:

- nodejs
- npx
- npm
- yarn
- pnpm
- pnpx

The image will track the latest `nodejs` LTS version and will use the `npm` version packaged with it.  
`yarn` and `pnpm` are installed via `corepack` using the stable version for `yarn` and latest for `pnpm`.
