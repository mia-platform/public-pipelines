# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.15.0@sha256:4026b29997dc7c823b51c164b71e2b51e0fd95cce4601f78202c513d97da2922 AS download

ARG TARGETARCH

# https://nodejs.org/download/release
ARG NODE_VERSION=v22.18.0
ARG NODE_CHECKSUM=c1bfeecf1d7404fa74728f9db72e697decbd8119ccc6f5a294d795756dfcfca7
ARG NODE_CHECKSUM_ARM=04fca1b9afecf375f26b41d65d52aa1703a621abea5a8948c7d1e351e85edade

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
