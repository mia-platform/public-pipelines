# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.18.0@sha256:d94d07ba9e7d6de898b6d96c1a072f6f8266c687af78a74f380087a0addf5d17 AS download

ARG TARGETARCH

# https://download.docker.com/linux/static/stable/
ARG DOCKER_VERSION=29.2.0

# https://github.com/docker/buildx/releases
ARG BUILDX_VERSION=v0.31.1
ARG BUILDX_CHECKSUM=dc8eaffbf29138123b4874d852522b12303c61246a5073fa0f025e4220317b1e
ARG BUILDX_CHECKSUM_ARM=963c674c558dad2eefd42304a09020329a196ed16819b72396e7657eb69f031b

# https://github.com/docker/compose/releases
ARG DOCKER_COMPOSE_VERSION=v5.0.2
ARG DOCKER_COMPOSE_CHECKSUM=2d880f723d3da7c779c54fdaea91a842fca8af55d1397f1ed8d7cbab3dd7af67
ARG DOCKER_COMPOSE_CHECKSUM_ARM=ac7810e0cd56a5b58576688196fafa843e07e8241fb91018a736d549ea20a3f3

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
