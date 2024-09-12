# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.10.0@sha256:a3838a5cf24fe940ec63e98fc37ce1dbe1d43286dc2b803c5bc5e9f067c7ad6d AS download

ARG TARGETARCH

# https://nodejs.org/download/release
ARG NODE_VERSION=v22.6.0
ARG NODE_CHECKSUM=acbbe539edc33209bb3e1b25f7545b5ca5d70e6256ed8318e1ec1e41e7b35703
ARG NODE_CHECKSUM_ARM=0053ee0426c4daaa65c44f2cef87be45135001c3145cfb840aa1d0e6f2619610

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
