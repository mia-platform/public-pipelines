# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.4.0@sha256:4a3396ae573c44932d06ba33f8696db4429c419da87cbdc82965ee96a37dd0af AS download

ARG TARGETARCH

# https://go.dev/dl
ARG GO_VERSION=1.21.4
ARG GO_CHECKSUM=73cac0215254d0c7d1241fa40837851f3b9a8a742d0b54714cbdfb3feaf8f0af
ARG GO_CHECKSUM_ARM=ce1983a7289856c3a918e1fd26d41e072cc39f928adfb11ba1896440849b95da

# https://github.com/golangci/golangci-lint/releases
ARG GOLANGCI_VERSION=1.55.2
ARG LINT_CHECKSUM=ca21c961a33be3bc15e4292dc40c98c8dcc5463a7b6768a3afc123761630c09c
ARG LINT_CHECKSUM_ARM=8eb0cee9b1dbf0eaa49871798c7f8a5b35f2960c52d776a5f31eb7d886b92746

# https://github.com/goreleaser/goreleaser/releases
ARG GORELEASER_VERSION=v1.22.1
ARG GORELEASER_CHECKSUM=62fc48004e9d7726e6756ae858846c69651463ac6dca5a934152072fdf0c1713
ARG GORELEASER_CHECKSUM_ARM=a0e21beea6c555d51c75a57301e576f4e35f4ae852e61888c79e0c6845d2e7dc

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
