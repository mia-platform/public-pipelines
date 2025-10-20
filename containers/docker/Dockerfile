# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.16.0@sha256:463eaf6072688fe96ac64fa623fe73e1dbe25d8ad6c34404a669ad3ce1f104b6 AS download

ARG TARGETARCH

# https://download.docker.com/linux/static/stable/
ARG DOCKER_VERSION=28.5.1

# https://github.com/docker/buildx/releases
ARG BUILDX_VERSION=v0.29.1
ARG BUILDX_CHECKSUM=7d2d7d6d4680aa349614965aaa33ccec43f1a9a21e908a5ce4cb6adfa5ad5141
ARG BUILDX_CHECKSUM_ARM=50e85c4e290b698908421161c1aee069bcc5d4a65b7b7201bfac3a176b223a7e

# https://github.com/docker/compose/releases
ARG DOCKER_COMPOSE_VERSION=v2.40.1
ARG DOCKER_COMPOSE_CHECKSUM=5bc26235e4de0be2aa350c13c33bd226d760d3b44cbd29820708788e02a2b6f2
ARG DOCKER_COMPOSE_CHECKSUM_ARM=ec4a385c4cd2afa4f5d429e6fe7dd6b2ae3dc251dc4e9332f1ad2cef8fa44554

USER root

RUN mkdir -p "/tmp/local/bin" "/tmp/local/lib/docker/cli-plugins"

RUN arch="$(uname -m)"; \
	curl -fsSL --proto '=https' --tlsv1.2 "https://download.docker.com/linux/static/stable/${arch}/docker-${DOCKER_VERSION}.tgz" -o "/tmp/docker.tgz" \
	&& tar -xvf "/tmp/docker.tgz" --no-same-permissions --no-same-owner -C "/tmp" \
	&& install -o "root" -g "root" -m "0755" "/tmp/docker/docker" "/tmp/local/bin/docker"

RUN case "${TARGETARCH}" in \
		'amd64') \
			buildx_checksum="${BUILDX_CHECKSUM}"; \
		;; \
		'arm64') \
			buildx_checksum="${BUILDX_CHECKSUM_ARM}"; \
		;; \
		*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	curl -fsSL --proto '=https' --tlsv1.2 "https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.linux-${TARGETARCH}" -o "/tmp/docker-buildx" \
	&& echo "${buildx_checksum} /tmp/docker-buildx" | sha256sum -c \
	&& install -o "root" -g "root" -m "0755" "/tmp/docker-buildx" "/tmp/local/lib/docker/cli-plugins/docker-buildx"

	RUN case "${TARGETARCH}" in \
	'amd64') \
		compose_checksum="${DOCKER_COMPOSE_CHECKSUM}"; \
		arch="x86_64"; \
	;; \
	'arm64') \
		compose_checksum="${DOCKER_COMPOSE_CHECKSUM_ARM}"; \
		arch="aarch64"; \
	;; \
	*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
esac; \
curl -fsSL --proto '=https' --tlsv1.2 "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-${arch}" -o "/tmp/docker-compose" \
&& echo "${compose_checksum} /tmp/docker-compose" | sha256sum -c \
&& install -o "root" -g "root" -m "0755" "/tmp/docker-compose" "/tmp/local/lib/docker/cli-plugins/docker-compose" \
&& install -o "root" -g "root" -m "0755" "/tmp/docker-compose" "/tmp/local/bin/docker-compose"

COPY ./docker_helpers.sh /tmp/local/lib

FROM ghcr.io/mia-platform/base-pipeline:1

ENV DOCKER_BUILDKIT=1

COPY --from=download /tmp/local /usr/local

RUN mkdir -p "/certs/client" && chmod 1777 "/certs" "/certs/client"
