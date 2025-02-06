# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.12.0@sha256:3dfa70a646c5d03ddf0e7c0ff518a5661e95b8bcbc82079f0fb7453a96eaae35 AS download

ARG TARGETARCH

# https://nodejs.org/download/release
ARG NODE_VERSION=v22.13.1
ARG NODE_CHECKSUM=0d2a5af33c7deab5555c8309cd3f373446fe1526c1b95833935ab3f019733b3b
ARG NODE_CHECKSUM_ARM=0a237c413ccbab920640438bf6e1a32edb19845bdc21f0e1cd5b91545ce1c126

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
	&& npm install -g playwright-core \
	&& playwright-core install-deps \
	&& apt-get autoremove --assume-yes \
	&& rm -rf /var/lib/apt/lists/*
