# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.7.1@sha256:25d29daeb9b14b89e2fa8cc17c70e4b188bca1466086907c2d9a4b56b59d8e21 AS download

ARG TARGETARCH

# https://download.docker.com/linux/static/stable/
ARG DOCKER_VERSION=26.0.0

# https://github.com/docker/buildx/releases
ARG BUILDX_VERSION=v0.13.1
ARG BUILDX_CHECKSUM=3e2bc8ed25a9125d6aeec07df4e0211edea6288e075b524160ef3fd305d3d74c
ARG BUILDX_CHECKSUM_ARM=3ba35a5d38361a64b62aeb9d20acc835ff6862a711cb438e610026b29c0ac489

# https://github.com/oras-project/oras/releases
ARG ORAS_VERSION=1.1.0
ARG ORAS_CHECKSUM=e09e85323b24ccc8209a1506f142e3d481e6e809018537c6b3db979c891e6ad7
ARG ORAS_CHECKSUM_ARM=e450b081f67f6fda2f16b7046075c67c9a53f3fda92fd20ecc59873b10477ab4

USER root

RUN mkdir -p "/tmp/local/bin" "/tmp/local/lib/docker/cli-plugins"

RUN arch="$(uname -m)"; \
	curl -fsSL "https://download.docker.com/linux/static/stable/${arch}/docker-${DOCKER_VERSION}.tgz" -o "/tmp/docker.tgz" \
	&& tar -xvf "/tmp/docker.tgz" --no-same-permissions --no-same-owner -C "/tmp" \
	&& install -o "root" -g "root" -m "0755" "/tmp/docker/docker" "/tmp/local/bin/docker"

RUN case "${TARGETARCH}" in \
		'amd64') \
			checksum="${BUILDX_CHECKSUM}"; \
		;; \
		'arm64') \
			checksum="${BUILDX_CHECKSUM_ARM}"; \
		;; \
		*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	curl -fsSL "https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.linux-${TARGETARCH}" -o "/tmp/docker-buildx" \
	&& echo "${checksum} /tmp/docker-buildx" | sha256sum -c \
	&& install -o "root" -g "root" -m "0755" "/tmp/docker-buildx" "/tmp/local/lib/docker/cli-plugins/docker-buildx"

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

COPY ./docker_helpers.sh /tmp/local/lib

FROM ghcr.io/mia-platform/base-pipeline:1

ENV DOCKER_BUILDKIT=1

COPY --from=download /tmp/local /usr/local

RUN mkdir -p "/certs/client" && chmod 1777 "/certs" "/certs/client"
