# Public Pipelines

![GitLab CI/CD Supported](https://img.shields.io/badge/GitLab-CI%2FCD-orange?logo=gitlab)

This repository contains a collection of components that aims to be used as stepping stones for setting up
CI/CD pipelines to be used with Mia-Platform Console to build and deploy containeraized services on Kubernetes.

The goals is to provide to Mia-Platform user reusable pipelines for different languages for building Docker images
to use in their projects and follow the best practicies for setting up comprehensive pipelines for building a project,
assessing its security, and keep track of its dependencies.

## Supported Tecnologies

| Language  | [GitLab CI/CD] | [GitHub Actions] | [Azure Pipelines] |
| --- | --- | --- | --- |
| [Node.js] | Yes, `npm` only | No | No |
| [Golang] | Yes | No | No |

[GitLab CI/CD]: https://docs.gitlab.com/ee/ci/ (GitLab CI documentation site)
[GitHub Actions]: https://docs.github.com/actions (GitHub Actions documentation site)
[Azure Pipelines]: https://azure.microsoft.com/products/devops/pipelines/ (Azure Piplines documentation site)
[Node.js]: https://nodejs.org (Node.js® is a JavaScript runtime built on Chrome's V8 JavaScript engine.)
[Golang]: https://go.dev (Go is an open source programming language that makes it simple to build secure, scalable systems.)
