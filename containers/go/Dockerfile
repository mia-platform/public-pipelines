# syntax=docker/dockerfile:1
FROM ghcr.io/mia-platform/base-pipeline:1

ARG TARGETARCH

ARG DEBIAN_FRONTEND=noninteractive

ARG GO_VERSION=1.21.0
ARG GO_CHECKSUM=d0398903a16ba2232b389fb31032ddf57cac34efda306a0eebac34f0965a0742
ARG GO_CHECKSUM_ARM=f3d4548edf9b22f26bbd49720350bbfe59d75b7090a1a2bff1afad8214febaf3
ARG GOLANGCI_VERSION=v1.54.2

RUN case "${TARGETARCH}" in \
		'amd64') \
			checksum="${GO_CHECKSUM}"; \
		;; \
		'arm64') \
			checksum="${GO_CHECKSUM_ARM}"; \
		;; \
		*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	wget --compression=auto https://go.dev/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz -O /tmp/go.tar.xz && \
	echo "${checksum} /tmp/go.tar.xz" | sha256sum -c - && \
	tar -xvf /tmp/go.tar.xz --strip-components 1 --no-same-owner -C /usr/local/ && \
	apt-get update && apt-get install -y make && \
	wget -O - https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | bash -s -- -b "$(go env GOPATH)/bin" ${GOLANGCI_VERSION} && \
	echo 'deb [trusted=yes] https://repo.goreleaser.com/apt/ /' | tee /etc/apt/sources.list.d/goreleaser.list && \
	apt update && \
	apt install -y goreleaser

ENV PATH="$PATH:/usr/local/go/bin:/root/go/bin"
