# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.11.0@sha256:83a505ba2ba62f208ed6e410c268b7b9aa48f0f7b403c8108b9773b44199dbba AS download

ARG TARGETARCH

# https://nodejs.org/download/release
ARG NODE_VERSION=v22.11.0
ARG NODE_CHECKSUM=83bf07dd343002a26211cf1fcd46a9d9534219aad42ee02847816940bf610a72
ARG NODE_CHECKSUM_ARM=6031d04b98f59ff0f7cb98566f65b115ecd893d3b7870821171708cdbaf7ae6e

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
	curl -fsSL "https://nodejs.org/download/release/${NODE_VERSION}/node-${NODE_VERSION}-linux-${arch}.tar.xz" -o "/tmp/node.tar.xz" \
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
	&& npm install -g playwright-core \
	&& playwright-core install-deps \
	&& apt-get autoremove --assume-yes \
	&& rm -rf /var/lib/apt/lists/*
