# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.19.0@sha256:b066cbf876d50a5d024927878a586c4a39c985325ded195e2e231f4abdddf3c8 AS download

ARG TARGETARCH

# https://github.com/sigstore/cosign/releases
ARG COSIGN_VERSION=v3.0.4
ARG COSIGN_CHECKSUM=10dab2fd2170b5aa0d5c0673a9a2793304960220b314f6a873bf39c2f08287aa
ARG COSIGN_CHECKSUM_ARM=c12fc6150195758ec0b1aeb1aade3381a1d3a299584982b66543f22bab04535b

# https://github.com/anchore/syft/releases
ARG SYFT_VERSION=1.42.0
ARG SYFT_CHECKSUM=23bec7de5db0ba05590c676a338a8cd49e635df63e6c404c34d437e2c57f1a77
ARG SYFT_CHECKSUM_ARM=cbc39a5f29b0bd32c1bf6bf61c363373f20a1be39dd901e1869228d42d082121

# https://github.com/oras-project/oras/releases
ARG ORAS_VERSION=1.3.0
ARG ORAS_CHECKSUM=6cdc692f929100feb08aa8de584d02f7bcc30ec7d88bc2adc2054d782db57c64
ARG ORAS_CHECKSUM_ARM=7649738b48fde10542bcc8b0e9b460ba83936c75fb5be01ee6d4443764a14352

# https://github.com/mikefarah/yq/releases
ARG YQ_VERSION=v4.52.4
ARG YQ_CHECKSUM=0c4d965ea944b64b8fddaf7f27779ee3034e5693263786506ccd1c120f184e8c
ARG YQ_CHECKSUM_ARM=4c2cc022a129be5cc1187959bb4b09bebc7fb543c5837b93001c68f97ce39a5d

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
