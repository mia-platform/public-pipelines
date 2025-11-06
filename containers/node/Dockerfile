# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.17.0@sha256:1e809b44e4cdf8a64a1bfe37875d4758a39454d686c2ff3c4a0fbeda93aae519 AS download

ARG TARGETARCH

# https://nodejs.org/download/release
ARG NODE_VERSION=v24.11.0
ARG NODE_CHECKSUM=46da9a098973ab7ba4fca76945581ecb2eaf468de347173897044382f10e0a0a
ARG NODE_CHECKSUM_ARM=33a6673b2c7bffeae9deec7f9f8b31aad9119b08f13d49b2ca3ee3bebfe8260f

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
