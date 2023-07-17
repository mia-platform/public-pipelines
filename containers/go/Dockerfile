# syntax=docker/dockerfile:1
FROM ghr.io/mia-platform/base-pipeline:1

ARG TARGETARCH

ARG GO_VERSION=1.20.5
ARG GO_CHECKSUM=d7ec48cde0d3d2be2c69203bc3e0a44de8660b9c09a6e85c4732a3f7dc442612
ARG GO_CHECKSUM_ARM=aa2fab0a7da20213ff975fa7876a66d47b48351558d98851b87d1cfef4360d09
ARG GOLANGCI_VERSION=v1.53.3

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
