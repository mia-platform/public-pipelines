# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.15.0@sha256:4026b29997dc7c823b51c164b71e2b51e0fd95cce4601f78202c513d97da2922 AS download

ARG TARGETARCH

# https://github.com/sigstore/cosign/releases
ARG COSIGN_VERSION=v2.5.2
ARG COSIGN_CHECKSUM=bcfeae05557a9f313ee4392d2f335d0ff69ebbfd232019e3736fb04999fe1734
ARG COSIGN_CHECKSUM_ARM=2cbcea1873ad76274c3f241ef175d204654e3aac3e73e6ec4504e5227015cb0a

# https://github.com/anchore/syft/releases
ARG SYFT_VERSION=1.28.0
ARG SYFT_CHECKSUM=3edee7fe1ceb1f78360e547f57048930d57f00c7ec3d0b8bdfb902805f048468
ARG SYFT_CHECKSUM_ARM=95c8533c46d4a952a576365f373d04fc0a4348e7335cbb82ac3ea2bc66e1e58b

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
