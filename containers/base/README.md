# Base Docker Image for Pipelines

This is a base Docker image that serves as the foundation for building other images in your project.

## Description

This Docker image is designed to provide a minimal and lightweight environment for building and running applications.
By using this base image, you can create more specialized and application-specific Docker images with ease.

## Contents

This image is based on Debian OS and include the following packages:

- cosign
- git
- git-lfs
- gnupg
- jq
- syft
- wget

Except for cosing and syft all the packages installed are the latest versions available during the image build,
for cosign and syft we pin the versions to download, but we will strive to keep them updated to the latests
versions available. But because part of the pipeline will use them we will evaluate if there are breaking changes. Test.
