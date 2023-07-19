# Node Docker Image for Pipelines

This is Docker image is used for the `nodejs` pipelines.

## Description

This Docker image is designed for use it inside the `nodejs` steps of the pipelines, and it install `nodejs` and
its major used package managers.

## Contents

This image is based on the build-base image and add this components:

- nodejs 18
- npx
- npm
- yarn
- pnpm
- pnpx

The image will track the latest `nodejs` LTS version and will use the `npm` version packaged with it.  
`yarn` and `pnpm` are installed via `corepack` using the stable version for `yarn` and latest for `pnpm`.
