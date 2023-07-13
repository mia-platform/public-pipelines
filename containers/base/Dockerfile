# syntax=docker/dockerfile:1
FROM debian:bookworm-slim

ARG TARGETARCH

ARG COSIGN_VERSION=v2.1.1
ARG COSIGN_CHECKSUM=84a859fb654e2c2c0cbc6433a8195fef60bccd16b4cf412f486c2c67d4b91241
ARG COSIGN_CHECKSUM_ARM=563ae4c2f03dd70a9b90e4058cdf14b3e33aa77d9dc6276ecb97473513c238f8

ARG SYFT_VERSION=0.84.1
ARG SYFT_CHECKSUM=05ebad9167254f03447103efea175d636c3cd27d0da7f79972ca78adc7c442f9
ARG SYFT_CHECKSUM_ARM=8b68b2cf046f8c3729753f7a414eb6546ac7b43bee3afd56f413601200cac3c2

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

CMD /bin/bash
