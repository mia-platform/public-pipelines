# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.10.0@sha256:a3838a5cf24fe940ec63e98fc37ce1dbe1d43286dc2b803c5bc5e9f067c7ad6d AS download

ARG TARGETARCH

# https://go.dev/dl
ARG GO_VERSION=1.22.5
ARG GO_CHECKSUM=904b924d435eaea086515bc63235b192ea441bd8c9b198c507e85009e6e4c7f0
ARG GO_CHECKSUM_ARM=8d21325bfcf431be3660527c1a39d3d9ad71535fabdf5041c826e44e31642b5a

# https://github.com/golangci/golangci-lint/releases
ARG GOLANGCI_VERSION=1.59.1
ARG LINT_CHECKSUM=c30696f1292cff8778a495400745f0f9c0406a3f38d8bb12cef48d599f6c7791
ARG LINT_CHECKSUM_ARM=8264507b560ae89dd080d5a0c7198ca5198e2b45f937a1f7fd873a8baa8e0b8f

# https://github.com/goreleaser/goreleaser/releases
ARG GORELEASER_VERSION=v2.1.0
ARG GORELEASER_CHECKSUM=4d4fb316acb3f5dfd45c7cd426f6120f8a294cb752d6cff46ad9b771f22f6f0d
ARG GORELEASER_CHECKSUM_ARM=fa1909b263b79b18a4b5eeba4710e59a023a0801f1aeb7317c5662511f69d851

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
