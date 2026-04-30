# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.20.0@sha256:b3f1fb2a51d923260350d21b8654bbc607164a987e2f7c84a0ac199a67df812a AS download

ARG TARGETARCH

# https://nodejs.org/download/release
ARG NODE_VERSION=v24.13.1
ARG NODE_CHECKSUM=30215f90ea3cd04dfbc06e762c021393fa173a1d392974298bbc871a8e461089
ARG NODE_CHECKSUM_ARM=c827d3d301e2eed1a51f36d0116b71b9e3d9e3b728f081615270ea40faac34c1

USER root

RUN mkdir -p "/tmp/local/bin"

RUN case "${TARGETARCH}" in \
	'amd64') \
	checksum="${NODE_CHECKSUM}"; \
	arch="x64"; \
	;; \
	'arm64') \
	checksum="${NODE_CHECKSUM_ARM}"; \
	arch="${TARGETARCH}"; \
	;; \
	*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	curl -fsSL --proto '=https' --tlsv1.2 "https://nodejs.org/download/release/${NODE_VERSION}/node-${NODE_VERSION}-linux-${arch}.tar.xz" -o "/tmp/node.tar.xz" \
	&& echo "${checksum} /tmp/node.tar.xz" | sha256sum -c - \
	&& tar -xvf "/tmp/node.tar.xz" --strip-components 1 --no-same-permissions --no-same-owner -C "/tmp/local" \
	&& rm -fr /tmp/local/*.md

FROM ghcr.io/mia-platform/base-pipeline:1

ARG DEBIAN_FRONTEND=noninteractive

COPY --from=download /tmp/local /usr/local

RUN apt-get update \
	&& corepack enable \
	&& corepack prepare yarn@stable --activate \
	&& corepack prepare pnpm@latest --activate \
	&& npx playwright-core install-deps \
	&& apt-get autoremove --assume-yes \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
