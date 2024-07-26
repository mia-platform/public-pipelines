# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.9.0@sha256:4c1cc1c836054961219e03d71e3f48a993aa40b92c3482eed316e50ede4889d9 AS download

ARG TARGETARCH

# https://github.com/sigstore/cosign/releases
ARG COSIGN_VERSION=v2.3.0
ARG COSIGN_CHECKSUM=5985b6ebbda2dd5aec4bd8c49e084393147d19170e7f7f4c30e664939e6972bf
ARG COSIGN_CHECKSUM_ARM=a4fae91128b136535fe3a12a7c1ccd3ce9f711d69d61ce94994ba34505ab017d

# https://github.com/anchore/syft/releases
ARG SYFT_VERSION=1.9.0
ARG SYFT_CHECKSUM=4c7db3f86a7cd86997fc37da412ac4c6031bb8d0a319a0b152791e53cd240ac4
ARG SYFT_CHECKSUM_ARM=9183b7f63e413e108854026378173fc2582de24c4ed58865cf8fbe9604213cce

USER root

RUN mkdir -p "/tmp/local/bin"

RUN case "${TARGETARCH}" in \
		'amd64') \
			cosign_checksum="${COSIGN_CHECKSUM}"; \
		;; \
		'arm64') \
			cosign_checksum="${COSIGN_CHECKSUM_ARM}"; \
		;; \
		*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	curl -fsSL "https://github.com/sigstore/cosign/releases/download/${COSIGN_VERSION}/cosign-linux-${TARGETARCH}" -o "/tmp/cosign" \
	&& echo "${cosign_checksum} /tmp/cosign" | sha256sum -c \
	&& install -o "root" -g "root" -m "0755" "/tmp/cosign" "/tmp/local/bin/cosign"

RUN case "${TARGETARCH}" in \
		'amd64') \
			syft_checksum="${SYFT_CHECKSUM}"; \
		;; \
		'arm64') \
			syft_checksum="${SYFT_CHECKSUM_ARM}"; \
		;; \
		*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	curl -fsSL "https://github.com/anchore/syft/releases/download/v${SYFT_VERSION}/syft_${SYFT_VERSION}_linux_${TARGETARCH}.tar.gz" -o "/tmp/syft.tar.gz" \
	&& echo "${syft_checksum} /tmp/syft.tar.gz" | sha256sum -c \
	&& tar -xvf "/tmp/syft.tar.gz" --no-same-permissions --no-same-owner -C "/tmp" \
	&& install -o "root" -g "root" -m "0755" "/tmp/syft" "/tmp/local/bin/syft"

FROM docker.io/library/debian:bookworm-slim

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
	&& apt-get autoremove --assume-yes \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=download /tmp/local /usr/local
