# syntax=docker/dockerfile:1
FROM ghcr.io/mia-platform/base-pipeline:1

ARG TARGETARCH

ARG DEBIAN_FRONTEND=noninteractive

ARG GO_VERSION=1.21.3
ARG GO_CHECKSUM=1241381b2843fae5a9707eec1f8fb2ef94d827990582c7c7c32f5bdfbfd420c8
ARG GO_CHECKSUM_ARM=fc90fa48ae97ba6368eecb914343590bbb61b388089510d0c56c2dde52987ef3
ARG GOLANGCI_VERSION=1.54.2
ARG LINT_CHECKSUM=17c9ca05253efe833d47f38caf670aad2202b5e6515879a99873fabd4c7452b3
ARG LINT_CHECKSUM_ARM=a9f14b33473c65fcfbf411ec054b53a87dbb849f4e09ee438f1ee76dbf3f3d4e
ARG GORELEASER_VERSION=v1.21.2
ARG GORELEASER_CHECKSUM=b669dbe65c3eeb99ce9a014d4115c6050cd100edc1e74c1569b1df6b175e5d0f
ARG GORELEASER_CHECKSUM_ARM=1f762e7aada4c5a6634be1a72cf89d763cad2e213b1394eb046cc0c3854533bd

RUN case "${TARGETARCH}" in \
		'amd64') \
			go_checksum="${GO_CHECKSUM}"; \
			lint_checksum="${LINT_CHECKSUM}"; \
			goreleaser_checksum="${GORELEASER_CHECKSUM}"; \
			goreleaser_arch="x86_64"; \
		;; \
		'arm64') \
			go_checksum="${GO_CHECKSUM_ARM}"; \
			lint_checksum="${LINT_CHECKSUM_ARM}"; \
			goreleaser_checksum="${GORELEASER_CHECKSUM_ARM}"; \
			goreleaser_arch="${TARGETARCH}"; \
		;; \
		*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	mkdir -p /tmp/golangci-lint /tmp/goreleaser && \
	wget --compression=auto https://go.dev/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz -O /tmp/go.tar.gz && \
	echo "${go_checksum} /tmp/go.tar.gz" | sha256sum -c - && \
	tar -xvf /tmp/go.tar.gz --no-same-owner -C /usr/local/ && \
	wget --compression=auto https://github.com/golangci/golangci-lint/releases/download/v${GOLANGCI_VERSION}/golangci-lint-${GOLANGCI_VERSION}-linux-${TARGETARCH}.tar.gz -O /tmp/golangci-lint.tar.gz && \
	echo "${lint_checksum} /tmp/golangci-lint.tar.gz" | sha256sum -c - && \
	tar -xvf /tmp/golangci-lint.tar.gz --strip-components 1 --no-same-owner -C /tmp/golangci-lint && \
	mv /tmp/golangci-lint/golangci-lint /usr/local/bin/ && \
	wget --compression=auto https://github.com/goreleaser/goreleaser/releases/download/${GORELEASER_VERSION}/goreleaser_Linux_${goreleaser_arch}.tar.gz -O /tmp/goreleaser.tar.gz && \
	echo "${goreleaser_checksum} /tmp/goreleaser.tar.gz" | sha256sum -c - && \
	tar -xvf /tmp/goreleaser.tar.gz --no-same-owner -C /tmp/goreleaser && \
	mv /tmp/goreleaser/goreleaser /usr/local/bin/ && \
	rm -fr /tmp/*

ENV PATH="/usr/local/go/bin:$PATH"
