# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.18.0@sha256:d94d07ba9e7d6de898b6d96c1a072f6f8266c687af78a74f380087a0addf5d17 AS download

ARG TARGETARCH

# https://github.com/sigstore/cosign/releases
ARG COSIGN_VERSION=v3.0.4
ARG COSIGN_CHECKSUM=10dab2fd2170b5aa0d5c0673a9a2793304960220b314f6a873bf39c2f08287aa
ARG COSIGN_CHECKSUM_ARM=c12fc6150195758ec0b1aeb1aade3381a1d3a299584982b66543f22bab04535b

# https://github.com/anchore/syft/releases
ARG SYFT_VERSION=1.41.2
ARG SYFT_CHECKSUM=7e0f45251d2a3998d29dfb6575bc662575dd5864c27bdc11625cc369760a17ad
ARG SYFT_CHECKSUM_ARM=cc2966835ea2c000d20c0b67f21b4f04d89150dffc09cd791e1a73e99965f0ca

# https://github.com/oras-project/oras/releases
ARG ORAS_VERSION=1.3.0
ARG ORAS_CHECKSUM=6cdc692f929100feb08aa8de584d02f7bcc30ec7d88bc2adc2054d782db57c64
ARG ORAS_CHECKSUM_ARM=7649738b48fde10542bcc8b0e9b460ba83936c75fb5be01ee6d4443764a14352

# https://github.com/mikefarah/yq/releases
ARG YQ_VERSION=v4.52.2
ARG YQ_CHECKSUM=a74bd266990339e0c48a2103534aef692abf99f19390d12c2b0ce6830385c459
ARG YQ_CHECKSUM_ARM=c82856ac30da522f50dcdd4f53065487b5a2927e9b87ff637956900986f1f7c2

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

RUN case "${TARGETARCH}" in \
	'amd64') \
	checksum="${YQ_CHECKSUM}"; \
	;; \
	'arm64') \
	checksum="${YQ_CHECKSUM_ARM}"; \
	;; \
	*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	curl -fsSL --proto '=https' --tlsv1.2 "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_${TARGETARCH}" -o "/tmp/yq" \
	&& echo "${checksum} /tmp/yq" | sha256sum -c \
	&& install -o "root" -g "root" -m "0755" "/tmp/yq" "/tmp/local/bin/yq"

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
	tzdata \
	wget \
	&& apt-get autoremove --assume-yes \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=download /tmp/local /usr/local
