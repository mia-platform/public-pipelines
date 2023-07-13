# syntax=docker/dockerfile:1
FROM nexus.mia-platform.eu/test-pipeline/build-base:latest

ARG TARGETARCH

ARG NODE_VERSION=v18.16.1
ARG NODE_CHECKSUM=ecfe263dbd9c239f37b5adca823b60be1bb57feabbccd25db785e647ebc5ff5e
ARG NODE_CHECKSUM_ARM=144eb4103e0193de8a41187817261d35970f1a13a11e779e16a4f1d9c99bcc82

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
	corepack prepare pnpm@latest --activate
