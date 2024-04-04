# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.7.1@sha256:25d29daeb9b14b89e2fa8cc17c70e4b188bca1466086907c2d9a4b56b59d8e21 AS download

ARG TARGETARCH

# https://download.docker.com/linux/static/stable/
ARG DOCKER_VERSION=26.0.0

# https://github.com/oras-project/oras/releases
ARG ORAS_VERSION=1.1.0
ARG ORAS_CHECKSUM=e09e85323b24ccc8209a1506f142e3d481e6e809018537c6b3db979c891e6ad7
ARG ORAS_CHECKSUM_ARM=e450b081f67f6fda2f16b7046075c67c9a53f3fda92fd20ecc59873b10477ab4

# https://docs.sysdig.com/en/docs/installation/sysdig-secure/install-vulnerability-cli-scanner/
ARG SYSDIG_SCANNER_VERSION=1.9.0
ARG SYSDIG_SCANNER_CHECKSUM=994f43d0f19421457b2469c3ad51b61067966f7f0c23367d4516e2f92a8c8c1a
ARG SYSDIG_SCANNER_CHECKSUM_ARM=61c0a2115d32cfdffd35bfd4040f678a3f7ef3a5c5c89b600f66828c6966f47e

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
