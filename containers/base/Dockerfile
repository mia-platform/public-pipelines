# syntax=docker/dockerfile:1
FROM debian:bookworm-slim

ARG TARGETARCH
ARG COSIGN_VERSION=v2.1.1
ARG COSIGN_CHECKSUM=84a859fb654e2c2c0cbc6433a8195fef60bccd16b4cf412f486c2c67d4b91241
ARG COSIGN_CHECKSUM_ARM=563ae4c2f03dd70a9b90e4058cdf14b3e33aa77d9dc6276ecb97473513c238f8

ARG SYFT_VERSION=0.85.0
ARG SYFT_CHECKSUM=2a92c69e1017e2bf3785886a8298ad2b94dda69f9f5623560999740986dd8420
ARG SYFT_CHECKSUM_ARM=fe96fc0c286feb554821ec1baf9367ad7122173998a8ca4ae2bcda844cd4a10a

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade --assume-yes && apt-get install --assume-yes --no-install-recommends \
	ca-certificates \
	bsdmainutils \
	git \
	git-lfs \
	gnupg \
	jq \
	tar \
	wget \
	xz-utils && \
	apt-get autoremove --assume-yes && \
	rm -rf /var/lib/apt/lists/*

# install cosign
RUN wget --compression=auto https://github.com/sigstore/cosign/releases/download/${COSIGN_VERSION}/cosign-linux-${TARGETARCH} -O /tmp/cosign && \
	case "${TARGETARCH}" in \
		'amd64') \
			checksum="${COSIGN_CHECKSUM}"; \
		;; \
		'arm64') \
			checksum="${COSIGN_CHECKSUM_ARM}"; \
		;; \
		*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	echo "${checksum} /tmp/cosign" | sha256sum -c - && \
	chmod +x /tmp/cosign && \
	mv /tmp/cosign /usr/local/bin

# install syft
RUN wget --compression=auto https://github.com/anchore/syft/releases/download/v${SYFT_VERSION}/syft_${SYFT_VERSION}_linux_${TARGETARCH}.tar.gz -O /tmp/syft.tar.gz && \
	case "${TARGETARCH}" in \
		'amd64') \
			checksum="${SYFT_CHECKSUM}"; \
		;; \
		'arm64') \
			checksum="${SYFT_CHECKSUM_ARM}"; \
		;; \
		*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	echo "${checksum} /tmp/syft.tar.gz" | sha256sum -c - && \
	mkdir -p /tmp/syft && \
	tar -xvf /tmp/syft.tar.gz --no-same-owner -C /tmp/syft && \
	mv /tmp/syft/syft /usr/local/bin/ && \
	rm -fr /tmp/syft
