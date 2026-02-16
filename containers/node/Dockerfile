# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.18.0@sha256:d94d07ba9e7d6de898b6d96c1a072f6f8266c687af78a74f380087a0addf5d17 AS download

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
