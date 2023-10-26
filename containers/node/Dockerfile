# syntax=docker/dockerfile:1
FROM ghcr.io/mia-platform/base-pipeline:1

ARG TARGETARCH

ARG NODE_VERSION=v20.9.0
ARG NODE_CHECKSUM=9033989810bf86220ae46b1381bdcdc6c83a0294869ba2ad39e1061f1e69217a
ARG NODE_CHECKSUM_ARM=ced3ecece4b7c3a664bca3d9e34a0e3b9a31078525283a6fdb7ea2de8ca5683b
ARG DEBIAN_FRONTEND=noninteractive

RUN case "${TARGETARCH}" in \
		'amd64') \
			checksum="${NODE_CHECKSUM}"; \
			arch=x64; \
		;; \
		'arm64') \
			checksum="${NODE_CHECKSUM_ARM}"; \
			arch=arm64; \
		;; \
		*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	wget --compression=auto https://nodejs.org/download/release/${NODE_VERSION}/node-${NODE_VERSION}-linux-${arch}.tar.xz -O /tmp/node.tar.xz && \
	echo "${checksum} /tmp/node.tar.xz" | sha256sum -c - && \
	tar -xvf /tmp/node.tar.xz --strip-components 1 --no-same-owner -C /usr/local && \
	rm -fr /usr/local/*.md /tmp/node.tar.xz && \
	corepack enable && \
	corepack prepare yarn@stable --activate && \
	corepack prepare pnpm@latest --activate && \
	npm install -g playwright-core && \
	apt-get update && \
	playwright-core install-deps && \
	apt-get autoremove --assume-yes && \
	rm -rf /var/lib/apt/lists/*
