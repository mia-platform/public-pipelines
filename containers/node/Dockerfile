# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.5.0@sha256:4bfa3e2c0164fb103fb9bfd4dc956facce32b6c5d47cc09fcec883ce9535d5ac AS download

ARG TARGETARCH

# https://nodejs.org/download/release
ARG NODE_VERSION=v20.11.0
ARG NODE_CHECKSUM=822780369d0ea309e7d218e41debbd1a03f8cdf354ebf8a4420e89f39cc2e612
ARG NODE_CHECKSUM_ARM=f6df68c6793244071f69023a9b43a0cf0b13d65cbe86d55925c28e4134d9aafb

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
