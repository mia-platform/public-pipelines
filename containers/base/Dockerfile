# syntax=docker/dockerfile:1
FROM debian:bookworm-slim

ARG TARGETARCH

ARG COSIGN_VERSION=v2.2.0
ARG COSIGN_CHECKSUM=5e4791fb7a5efaaa98da651534789ec985ce8ac9c31910a810fc249f86ba2ef9
ARG COSIGN_CHECKSUM_ARM=5adbb7b1d38ac19a15c6bd9a61725baa16f61e23611534eb5e6d377dc024e102

ARG SYFT_VERSION=0.93.0
ARG SYFT_CHECKSUM=5fb0eb70c0f618e9a8b93d68b59da4b5758164b1aacc062e2150341baf7acc73
ARG SYFT_CHECKSUM_ARM=f2f8889305350ee3a53a012246acfa10b59b7aee67e9b6a2e811f05b67f74588

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
RUN case "${TARGETARCH}" in \
		'amd64') \
			cosign_checksum="${COSIGN_CHECKSUM}"; \
			syft_checksum="${SYFT_CHECKSUM}"; \
		;; \
		'arm64') \
			cosign_checksum="${COSIGN_CHECKSUM_ARM}"; \
			syft_checksum="${SYFT_CHECKSUM_ARM}"; \
		;; \
		*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	mkdir -p /tmp/syft && \
	wget --compression=auto https://github.com/sigstore/cosign/releases/download/${COSIGN_VERSION}/cosign-linux-${TARGETARCH} -O /tmp/cosign && \
	echo "${cosign_checksum} /tmp/cosign" | sha256sum -c - && \
	chmod +x /tmp/cosign && \
	mv /tmp/cosign /usr/local/bin && \
	wget --compression=auto https://github.com/anchore/syft/releases/download/v${SYFT_VERSION}/syft_${SYFT_VERSION}_linux_${TARGETARCH}.tar.gz -O /tmp/syft.tar.gz && \
	echo "${syft_checksum} /tmp/syft.tar.gz" | sha256sum -c - && \
	tar -xvf /tmp/syft.tar.gz --no-same-owner -C /tmp/syft && \
	mv /tmp/syft/syft /usr/local/bin/ && \
	rm -fr /tmp/*
