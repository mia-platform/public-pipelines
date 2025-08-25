# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.15.0@sha256:4026b29997dc7c823b51c164b71e2b51e0fd95cce4601f78202c513d97da2922 AS download

ARG TARGETARCH

# https://github.com/sigstore/cosign/releases
ARG COSIGN_VERSION=v2.5.3
ARG COSIGN_CHECKSUM=783b5d6c74105401c63946c68d9b2a4e1aab3c8abce043e06b8510b02b623ec9
ARG COSIGN_CHECKSUM_ARM=bffabe4cf183122b7de3111257a863c99e7dc6cf1093bfd7bf961de1795589b8

# https://github.com/anchore/syft/releases
ARG SYFT_VERSION=1.31.0
ARG SYFT_CHECKSUM=aa60fbe2a32453e7dea991c9c5c616ae1fff0c51e910419ae53bc6555bfd2ce2
ARG SYFT_CHECKSUM_ARM=2b288960f4c8ed25d529a644a20e059b60ae4b6f58d4a7bb20c8795bfb90b34c

# https://github.com/oras-project/oras/releases
ARG ORAS_VERSION=1.2.3
ARG ORAS_CHECKSUM=b4efc97a91f471f323f193ea4b4d63d8ff443ca3aab514151a30751330852827
ARG ORAS_CHECKSUM_ARM=90e24e234dc6dffe73365533db66fd14449d2c9ae77381081596bf92f40f6b82

USER root

RUN mkdir -p "/tmp/local/bin" "/tmp/local/lib"

RUN case "${TARGETARCH}" in \
		'amd64') \
			cosign_checksum="${COSIGN_CHECKSUM}"; \
		;; \
		'arm64') \
			cosign_checksum="${COSIGN_CHECKSUM_ARM}"; \
		;; \
		*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	curl -fsSL --proto '=https' --tlsv1.2 "https://github.com/sigstore/cosign/releases/download/${COSIGN_VERSION}/cosign-linux-${TARGETARCH}" -o "/tmp/cosign" \
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
	curl -fsSL --proto '=https' --tlsv1.2 "https://github.com/anchore/syft/releases/download/v${SYFT_VERSION}/syft_${SYFT_VERSION}_linux_${TARGETARCH}.tar.gz" -o "/tmp/syft.tar.gz" \
	&& echo "${syft_checksum} /tmp/syft.tar.gz" | sha256sum -c \
	&& tar -xvf "/tmp/syft.tar.gz" --no-same-permissions --no-same-owner -C "/tmp" \
	&& install -o "root" -g "root" -m "0755" "/tmp/syft" "/tmp/local/bin/syft"

RUN case "${TARGETARCH}" in \
	'amd64') \
		checksum="${ORAS_CHECKSUM}"; \
	;; \
	'arm64') \
		checksum="${ORAS_CHECKSUM_ARM}"; \
	;; \
	*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
esac; \
curl -fsSL --proto '=https' --tlsv1.2 "https://github.com/oras-project/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_linux_${TARGETARCH}.tar.gz" -o "/tmp/oras.tar.gz" \
&& echo "${checksum} /tmp/oras.tar.gz" | sha256sum -c \
&& tar -xvf "/tmp/oras.tar.gz" --no-same-permissions --no-same-owner -C "/tmp" \
&& install -o "root" -g "root" -m "0755" "/tmp/oras" "/tmp/local/bin/oras"

COPY ./base_helpers.sh /tmp/local/lib

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
