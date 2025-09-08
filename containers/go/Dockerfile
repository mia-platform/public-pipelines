# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.15.0@sha256:4026b29997dc7c823b51c164b71e2b51e0fd95cce4601f78202c513d97da2922 AS download

ARG TARGETARCH

# https://go.dev/dl
ARG GO_VERSION=1.25.1
ARG GO_CHECKSUM=7716a0d940a0f6ae8e1f3b3f4f36299dc53e31b16840dbd171254312c41ca12e
ARG GO_CHECKSUM_ARM=65a3e34fb2126f55b34e1edfc709121660e1be2dee6bdf405fc399a63a95a87d

# the 2.x version will be available only from the 1.25 release
# https://github.com/golangci/golangci-lint/releases
ARG GOLANGCI_VERSION=2.4.0
ARG LINT_CHECKSUM=fae792524c04424c0ac369f5b8076f04b45cf29fc945a370e55d369a8dc11840
ARG LINT_CHECKSUM_ARM=70ac11f55b80ec78fd3a879249cc9255121b8dfd7f7ed4fc46ed137f4abf17e7

# https://github.com/goreleaser/goreleaser/releases
ARG GORELEASER_VERSION=v2.12.0
ARG GORELEASER_CHECKSUM=0c8915d91a491b1349fe4288eb8541d3876c5187be7f7e614bfc3fe442cf06d1
ARG GORELEASER_CHECKSUM_ARM=d36fd20b66431dba7ee4c5ffc6f4d1b37c876d694d65ced1ff4911c143d8e66d

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
