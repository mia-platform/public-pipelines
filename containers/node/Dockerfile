# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.10.0@sha256:a3838a5cf24fe940ec63e98fc37ce1dbe1d43286dc2b803c5bc5e9f067c7ad6d AS download

ARG TARGETARCH

# https://nodejs.org/download/release
ARG NODE_VERSION=v22.8.0
ARG NODE_CHECKSUM=b6827dccd983acad09496f28a0f277218cc49302a8a7179ccbd7bf38305f5623
ARG NODE_CHECKSUM_ARM=9498fec4ce1ac2178d48dea825c012ca2ab532486824b8ed0dd3a7ffae87db0f

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
