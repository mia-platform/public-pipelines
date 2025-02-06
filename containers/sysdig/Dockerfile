# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.12.0@sha256:3dfa70a646c5d03ddf0e7c0ff518a5661e95b8bcbc82079f0fb7453a96eaae35 AS download

ARG TARGETARCH

# https://download.docker.com/linux/static/stable/
ARG DOCKER_VERSION=27.5.1

# https://github.com/oras-project/oras/releases
ARG ORAS_VERSION=1.2.2
ARG ORAS_CHECKSUM=bff970346470e5ef888e9f2c0bf7f8ee47283f5a45207d6e7a037da1fb0eae0d
ARG ORAS_CHECKSUM_ARM=edd7195cbb8ba56c29ede413eefa10c8026201d63326017cd315841b4063aa56

# https://docs.sysdig.com/en/docs/installation/sysdig-secure/install-vulnerability-cli-scanner/
ARG SYSDIG_SCANNER_VERSION=1.19.2
ARG SYSDIG_SCANNER_CHECKSUM=1fca987fab363931e31f085996a5e4ad8c5d096baea8f84a5d10e4a426067e13
ARG SYSDIG_SCANNER_CHECKSUM_ARM=b82d54f596edf2649288458a5963096b0758430216e8deebc6799db8ed44e430

USER root

RUN mkdir -p "/tmp/local/bin"

RUN arch="$(uname -m)"; \
	curl -fsSL --proto '=https' --tlsv1.2 "https://download.docker.com/linux/static/stable/${arch}/docker-${DOCKER_VERSION}.tgz" -o "/tmp/docker.tgz" \
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
	curl -fsSL --proto '=https' --tlsv1.2 "https://github.com/oras-project/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_linux_${TARGETARCH}.tar.gz" -o "/tmp/oras.tar.gz" \
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
	curl -fsSL --proto '=https' --tlsv1.2 "https://download.sysdig.com/scanning/bin/sysdig-cli-scanner/${SYSDIG_SCANNER_VERSION}/linux/${TARGETARCH}/sysdig-cli-scanner" -o "/tmp/sysdig-cli-scanner" \
	&& echo "${checksum} /tmp/sysdig-cli-scanner" | sha256sum -c \
	&& install -o "root" -g "root" -m "0755" "/tmp/sysdig-cli-scanner" "/tmp/local/bin/sysdig-cli-scanner"

FROM ghcr.io/mia-platform/base-pipeline:1

COPY --from=download /tmp/local /usr/local
