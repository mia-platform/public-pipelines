# syntax=docker/dockerfile:1
FROM ghcr.io/mia-platform/base-pipeline:1

ARG TARGETARCH

ARG NODE_VERSION=v18.17.1
ARG NODE_CHECKSUM=07e76408ddb0300a6f46fcc9abc61f841acde49b45020ec4e86bb9b25df4dced
ARG NODE_CHECKSUM_ARM=3f933716a468524acb68c2514d819b532131eb50399ee946954d4a511303e1bb
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
