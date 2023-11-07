# Mia-Platform Pipelines

In case you don‘t have a unified pipeline strategy for building libraries and Docker images, you can start with
our pipelines. They are a starting step for quickly setting them up following best practictes and trying to
add useful steps that can match regulatory compliance for your company.

## Supported Tecnologies

Here you can find all the languages and CI/CD systems currently supported:

| Language  | [GitLab CI/CD]
| --- | --- |
| [Node.js] with [NPM] | Yes |
| [Node.js] with [Yarn] | Yes |
| [Go] | Yes |

## GitLab CI/CD

For GitLab CI/CD you can follow the following guides:

- [Installation](./20-gitlab-installation.md): how to setup the templates in your SaaS or Self-managed instance
- [Templates](./gitlab-ci/10-templates.md): a rundown of all the templates files and what they contains

[GitLab CI/CD]: https://docs.gitlab.com/ee/ci/ (GitLab CI documentation site)
[Node.js]: https://nodejs.org (Node.js® is a JavaScript runtime built on Chrome’s V8 JavaScript engine)
[NPM]: https://www.npmjs.com (npm is the world’s largest software registry)
[Yarn]: https://yarnpkg.com (Yarn is a package manager that doubles down as project manager)
[Go]: https://go.dev (Go is an open source programming language that makes it simple to build secure, scalable systems)
