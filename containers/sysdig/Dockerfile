# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.10.1@sha256:d9b4541e214bcd85196d6e92e2753ac6d0ea699f0af5741f8c6cccbfcf00ef4b AS download

ARG TARGETARCH

# https://download.docker.com/linux/static/stable/
ARG DOCKER_VERSION=27.3.1

# https://github.com/oras-project/oras/releases
ARG ORAS_VERSION=1.2.0
ARG ORAS_CHECKSUM=5b3f1cbb86d869eee68120b9b45b9be983f3738442f87ee5f06b00edd0bab336
ARG ORAS_CHECKSUM_ARM=27df680a39fc2fcedc549cb737891623bc696c9a92a03fd341e9356a35836bae

# https://docs.sysdig.com/en/docs/installation/sysdig-secure/install-vulnerability-cli-scanner/
ARG SYSDIG_SCANNER_VERSION=1.17.0
ARG SYSDIG_SCANNER_CHECKSUM=96ce6239d4931458f78f5a5cf507763d8a92f583ff04f401bef13ab55751d075
ARG SYSDIG_SCANNER_CHECKSUM_ARM=e51df0a587fea2844b41bca95712a9ed036049dfc31e6101f92995a36a806ca0

USER root

RUN mkdir -p "/tmp/local/bin"

RUN arch="$(uname -m)"; \
	curl -fsSL "https://download.docker.com/linux/static/stable/${arch}/docker-${DOCKER_VERSION}.tgz" -o "/tmp/docker.tgz" \
	&& tar -xvf "/tmp/docker.tgz" --no-same-permissions --no-same-owner -C "/tmp" \
	&& install -o "root" -g "root" -m "0755" "/tmp/docker/docker" "/tmp/local/bin/docker"

RUN case "${TARGETARCH}" in \
		'amd64') \
			checksum="${ORAS_CHECKSUM}"; \
		;; \
		'arm64') \
			checksum="${ORAS_CHECKSUM_ARM}"; \
		;; \
		*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	curl -fsSL "https://github.com/oras-project/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_linux_${TARGETARCH}.tar.gz" -o "/tmp/oras.tar.gz" \
	&& echo "${checksum} /tmp/oras.tar.gz" | sha256sum -c \
	&& tar -xvf "/tmp/oras.tar.gz" --no-same-permissions --no-same-owner -C "/tmp" \
	&& install -o "root" -g "root" -m "0755" "/tmp/oras" "/tmp/local/bin/oras"

RUN case "${TARGETARCH}" in \
		'amd64') \
			checksum="${SYSDIG_SCANNER_CHECKSUM}"; \
		;; \
		'arm64') \
			checksum="${SYSDIG_SCANNER_CHECKSUM_ARM}"; \
		;; \
		*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1 ;; \
	esac; \
	curl -fsSL "https://download.sysdig.com/scanning/bin/sysdig-cli-scanner/${SYSDIG_SCANNER_VERSION}/linux/${TARGETARCH}/sysdig-cli-scanner" -o "/tmp/sysdig-cli-scanner" \
	&& echo "${checksum} /tmp/sysdig-cli-scanner" | sha256sum -c \
	&& install -o "root" -g "root" -m "0755" "/tmp/sysdig-cli-scanner" "/tmp/local/bin/sysdig-cli-scanner"

FROM ghcr.io/mia-platform/base-pipeline:1

COPY --from=download /tmp/local /usr/local
