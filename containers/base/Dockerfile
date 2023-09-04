# syntax=docker/dockerfile:1
FROM debian:bookworm-slim

ARG TARGETARCH

ARG COSIGN_VERSION=v2.2.0
ARG COSIGN_CHECKSUM=5e4791fb7a5efaaa98da651534789ec985ce8ac9c31910a810fc249f86ba2ef9
ARG COSIGN_CHECKSUM_ARM=5adbb7b1d38ac19a15c6bd9a61725baa16f61e23611534eb5e6d377dc024e102

ARG SYFT_VERSION=0.89.0
ARG SYFT_CHECKSUM=b7cc7c1fb588454947ca678df7ddd906620d399a05f92a550b1b2d312fb26764
ARG SYFT_CHECKSUM_ARM=1c1c8e53d7157c3e861116e24eb494da0b660b3757ea69d6e05038c6ed76c50f

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
