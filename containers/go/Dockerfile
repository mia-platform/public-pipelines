# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.12.1@sha256:94e9e444bcba979c2ea12e27ae39bee4cd10bc7041a472c4727a558e213744e6 AS download

ARG TARGETARCH

# https://go.dev/dl
ARG GO_VERSION=1.24.0
ARG GO_CHECKSUM=dea9ca38a0b852a74e81c26134671af7c0fbe65d81b0dc1c5bfe22cf7d4c8858
ARG GO_CHECKSUM_ARM=c3fa6d16ffa261091a5617145553c71d21435ce547e44cc6dfb7470865527cc7

# https://github.com/golangci/golangci-lint/releases
ARG GOLANGCI_VERSION=1.64.5
ARG LINT_CHECKSUM=e6bd399a0479c5fd846dcf9f3990d20448b4f0d1e5027d82348eab9f80f7ac71
ARG LINT_CHECKSUM_ARM=59df27f9a82e461b00597c5f6d96c6a46bfdb4b7cddd9341502641d3d874a65a

# https://github.com/goreleaser/goreleaser/releases
ARG GORELEASER_VERSION=v2.7.0
ARG GORELEASER_CHECKSUM=075cb78e414664e50ee6900dd93ff1748c2d3fce19c9830f40186e99fc90ba0e
ARG GORELEASER_CHECKSUM_ARM=5b3646cef976ea610019d4ee5523e4fb1b243e4e89a416ff9b9ac645c7e26342

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
