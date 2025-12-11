# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.17.0@sha256:935d9100e9ba842cdb060de42472c7ca90cfe9a7c96e4dacb55e79e560b3ff40 AS download

ARG TARGETARCH

# https://github.com/sigstore/cosign/releases
ARG COSIGN_VERSION=v3.0.3
ARG COSIGN_CHECKSUM=052363a0e23e2e7ed53641351b8b420918e7e08f9c1d8a42a3dd3877a78a2e10
ARG COSIGN_CHECKSUM_ARM=81398231362031e3c7afd6a7508c57049460cd7e02736f1ebe89a452102253e5

# https://github.com/anchore/syft/releases
ARG SYFT_VERSION=1.38.2
ARG SYFT_CHECKSUM=6aa9a7b9e53c0f06e2d79fb24641cc1c856bb41702c282a577691f54bad94996
ARG SYFT_CHECKSUM_ARM=ccd95833d4124f0e30925033908934978086727af69585f015f28a4f355fda1b

# https://github.com/oras-project/oras/releases
ARG ORAS_VERSION=1.3.0
ARG ORAS_CHECKSUM=6cdc692f929100feb08aa8de584d02f7bcc30ec7d88bc2adc2054d782db57c64
ARG ORAS_CHECKSUM_ARM=7649738b48fde10542bcc8b0e9b460ba83936c75fb5be01ee6d4443764a14352

# https://github.com/mikefarah/yq/releases
ARG YQ_VERSION=v4.49.2
ARG YQ_CHECKSUM=be2c0ddcf426b6a231648610ec5d1666ae50e9f6473e82f6486f9f4cb6e3e2f7
ARG YQ_CHECKSUM_ARM=783aa3c3beedcf2bf4aaf6262eca38b92a16d3ea31e2218ca80ba8ec7226b248

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
