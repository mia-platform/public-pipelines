# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.13.0@sha256:d43bdb28bae0be0998f3be83199bfb2b81e0a30b034b6d7586ce7e05de34c3fd AS download

ARG TARGETARCH

# https://nodejs.org/download/release
ARG NODE_VERSION=v22.15.1
ARG NODE_CHECKSUM=7dca2ab34ec817aa4781e2e99dfd34d349eff9be86e5d5fbaa7e96cae8ee3179
ARG NODE_CHECKSUM_ARM=f4ae8ddf7487dfaf7da92fef463ee55cc29d8772d62891361dc3fc8b8e469205

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
