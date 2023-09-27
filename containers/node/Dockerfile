# syntax=docker/dockerfile:1
FROM ghcr.io/mia-platform/base-pipeline:1

ARG TARGETARCH

ARG NODE_VERSION=v18.19.0
ARG NODE_CHECKSUM=3008408e9098f2462f7b1a0f6a48b8a46079beb1c92b6ec43b04713265c96978
ARG NODE_CHECKSUM_ARM=e2931643cc3ee37375ae5c6dc2028ff526948a227d9fd5d481316240de6e58a5
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
