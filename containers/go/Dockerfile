# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.11.0@sha256:83a505ba2ba62f208ed6e410c268b7b9aa48f0f7b403c8108b9773b44199dbba AS download

ARG TARGETARCH

# https://go.dev/dl
ARG GO_VERSION=1.23.3
ARG GO_CHECKSUM=a0afb9744c00648bafb1b90b4aba5bdb86f424f02f9275399ce0c20b93a2c3a8
ARG GO_CHECKSUM_ARM=1f7cbd7f668ea32a107ecd41b6488aaee1f5d77a66efd885b175494439d4e1ce

# https://github.com/golangci/golangci-lint/releases
ARG GOLANGCI_VERSION=1.62.0
ARG LINT_CHECKSUM=53695531eeb824b6883c703335cef6f07882f8ba6fedc00ed43853ea07fa1fbd
ARG LINT_CHECKSUM_ARM=e1e47209d7bdd288fd8cfe88548b477df2f7eca81b0e9ec1f9d45604f79185eb

# https://github.com/goreleaser/goreleaser/releases
ARG GORELEASER_VERSION=v2.4.4
ARG GORELEASER_CHECKSUM=be4c47a22a020eeda3640a88a6e2e02cb565f469180347d89e193659dd84c15e
ARG GORELEASER_CHECKSUM_ARM=bd0d3d6f9e04e302ca16eece1a0fdcdc3c5d99861e2882aa06caefb17913c687

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
	curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz" -o "/tmp/go.tar.gz" \
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
	curl -fsSL "https://github.com/golangci/golangci-lint/releases/download/v${GOLANGCI_VERSION}/golangci-lint-${GOLANGCI_VERSION}-linux-${TARGETARCH}.tar.gz" -o "/tmp/golangci-lint.tar.gz" \
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
	curl -fsSL "https://github.com/goreleaser/goreleaser/releases/download/${GORELEASER_VERSION}/goreleaser_Linux_${goreleaser_arch}.tar.gz" -o "/tmp/goreleaser.tar.gz" \
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
