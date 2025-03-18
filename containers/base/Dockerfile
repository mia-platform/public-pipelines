# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.12.1@sha256:94e9e444bcba979c2ea12e27ae39bee4cd10bc7041a472c4727a558e213744e6 AS download

ARG TARGETARCH

# https://github.com/sigstore/cosign/releases
ARG COSIGN_VERSION=v2.4.3
ARG COSIGN_CHECKSUM=caaad125acef1cb81d58dcdc454a1e429d09a750d1e9e2b3ed1aed8964454708
ARG COSIGN_CHECKSUM_ARM=bd0f9763bca54de88699c3656ade2f39c9a1c7a2916ff35601caf23a79be0629

# https://github.com/anchore/syft/releases
ARG SYFT_VERSION=1.21.0
ARG SYFT_CHECKSUM=0ee8161dfa4f79487e46e734305a414e1e7fbcdc114d69809d069e89483c4898
ARG SYFT_CHECKSUM_ARM=b7617868459cb707e4f9f56c8cb121124bf90b2c944f30e2f3c773807e1e05d7

# https://github.com/oras-project/oras/releases
ARG ORAS_VERSION=1.2.2
ARG ORAS_CHECKSUM=bff970346470e5ef888e9f2c0bf7f8ee47283f5a45207d6e7a037da1fb0eae0d
ARG ORAS_CHECKSUM_ARM=edd7195cbb8ba56c29ede413eefa10c8026201d63326017cd315841b4063aa56

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
