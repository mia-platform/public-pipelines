# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.7.1@sha256:25d29daeb9b14b89e2fa8cc17c70e4b188bca1466086907c2d9a4b56b59d8e21 AS download

ARG TARGETARCH

# https://nodejs.org/download/release
ARG NODE_VERSION=v20.13.0
ARG NODE_CHECKSUM=a58d5d99b4ccf95d966dd1e3d3a560f4686e3e1e4f7331258860d429f13fc7eb
ARG NODE_CHECKSUM_ARM=44abc8a22d723fd0946b18c6339016a8882eb850e8fc26ea4f470de9545be778

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
