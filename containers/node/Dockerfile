# syntax=docker/dockerfile:1
FROM ghcr.io/mia-platform/base-pipeline:1

ARG TARGETARCH

ARG NODE_VERSION=v18.18.1
ARG NODE_CHECKSUM=1db684d7da5fec4ae335ac5d8049a10a8bf30bad9e1d0aa9dcd92baa1f90c6e5
ARG NODE_CHECKSUM_ARM=753f90c57173948d06e750a01c49466c3af532e915abead90fd07507daa98ff1
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
