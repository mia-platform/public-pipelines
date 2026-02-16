# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.18.0@sha256:d94d07ba9e7d6de898b6d96c1a072f6f8266c687af78a74f380087a0addf5d17 AS download

ARG TARGETARCH

# https://go.dev/dl
ARG GO_VERSION=1.26.0
ARG GO_CHECKSUM=aac1b08a0fb0c4e0a7c1555beb7b59180b05dfc5a3d62e40e9de90cd42f88235
ARG GO_CHECKSUM_ARM=bd03b743eb6eb4193ea3c3fd3956546bf0e3ca5b7076c8226334afe6b75704cd

# the 2.x version will be available only from the 1.25 release
# https://github.com/golangci/golangci-lint/releases
ARG GOLANGCI_VERSION=2.9.0
ARG LINT_CHECKSUM=493aaaca2eba6c8bcef847d92716bbd91bbac4b22cdbb0ab5b6a581b32946091
ARG LINT_CHECKSUM_ARM=94e80cdb51c73c20a313bd3afa1fb23137728813c19fd730248a1e8678fcc46d

# https://github.com/goreleaser/goreleaser/releases
ARG GORELEASER_VERSION=v2.13.3
ARG GORELEASER_CHECKSUM=4b66f2f78f78561330350651ade557b70328664718490f37834749073af21d20
ARG GORELEASER_CHECKSUM_ARM=156656d0f874542d618568bd50afd3d33ced2e8aab2c60cc7c21e1b9fa52031e

USER root

RUN mkdir -p "/tmp/local/bin"

RUN case "${TARGETARCH}" in \
	'amd64') \
	go_checksum="${GO_CHECKSUM}"; \
	;; \
	'arm64') \
	go_checksum="${GO_CHECKSUM_ARM}"; \
	;; \
	*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	curl -fsSL --proto '=https' --tlsv1.2 "https://go.dev/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz" -o "/tmp/go.tar.gz" \
	&& echo "${go_checksum} /tmp/go.tar.gz" | sha256sum -c \
	&& tar -xvf "/tmp/go.tar.gz" --no-same-permissions --no-same-owner -C "/tmp/local"

RUN case "${TARGETARCH}" in \
	'amd64') \
	lint_checksum="${LINT_CHECKSUM}"; \
	;; \
	'arm64') \
	lint_checksum="${LINT_CHECKSUM_ARM}"; \
	;; \
	*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	curl -fsSL --proto '=https' --tlsv1.2 "https://github.com/golangci/golangci-lint/releases/download/v${GOLANGCI_VERSION}/golangci-lint-${GOLANGCI_VERSION}-linux-${TARGETARCH}.tar.gz" -o "/tmp/golangci-lint.tar.gz" \
	&& echo "${lint_checksum} /tmp/golangci-lint.tar.gz" | sha256sum -c \
	&& tar -xvf "/tmp/golangci-lint.tar.gz" --no-same-permissions --no-same-owner -C "/tmp" \
	&& install -o "root" -g "root" -m "0755" "/tmp/golangci-lint-${GOLANGCI_VERSION}-linux-${TARGETARCH}/golangci-lint" "/tmp/local/bin/golangci-lint"

RUN case "${TARGETARCH}" in \
	'amd64') \
	goreleaser_checksum="${GORELEASER_CHECKSUM}"; \
	goreleaser_arch="x86_64"; \
	;; \
	'arm64') \
	goreleaser_checksum="${GORELEASER_CHECKSUM_ARM}"; \
	goreleaser_arch="${TARGETARCH}"; \
	;; \
	*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	curl -fsSL --proto '=https' --tlsv1.2 "https://github.com/goreleaser/goreleaser/releases/download/${GORELEASER_VERSION}/goreleaser_Linux_${goreleaser_arch}.tar.gz" -o "/tmp/goreleaser.tar.gz" \
	&& echo "${goreleaser_checksum} /tmp/goreleaser.tar.gz" | sha256sum -c \
	&& tar -xvf "/tmp/goreleaser.tar.gz" --no-same-permissions --no-same-owner -C "/tmp" \
	&& install -o "root" -g "root" -m "0755" "/tmp/goreleaser" "/tmp/local/bin/goreleaser"

FROM ghcr.io/mia-platform/base-pipeline:1

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --assume-yes --no-install-recommends \
	make \
	g++ \
	&& apt-get autoremove --assume-yes \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=download /tmp/local /usr/local

ENV PATH="/usr/local/go/bin:$PATH"
