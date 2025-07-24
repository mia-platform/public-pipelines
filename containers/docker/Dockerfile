# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.15.0@sha256:4026b29997dc7c823b51c164b71e2b51e0fd95cce4601f78202c513d97da2922 AS download

ARG TARGETARCH

# https://download.docker.com/linux/static/stable/
ARG DOCKER_VERSION=28.3.2

# https://github.com/docker/buildx/releases
ARG BUILDX_VERSION=v0.26.1
ARG BUILDX_CHECKSUM=9451034b6ca5354e8bf88a2002a413aedabf110fd0f12ebb0b2f2cc241be8e41
ARG BUILDX_CHECKSUM_ARM=b610d3c24836b2e7fecab5ef2c9466239a0f0156993a0406ea58943b87bff918

# https://github.com/docker/compose/releases
ARG DOCKER_COMPOSE_VERSION=v2.38.2
ARG DOCKER_COMPOSE_CHECKSUM=486b3ffc0f806ca2efbc430cef89955386011662f0c76bad17c103d059cfa9cf
ARG DOCKER_COMPOSE_CHECKSUM_ARM=4d0f7678dd3338452beba4518e36a8e22b20cad79ba2535c687da554dc3997fb

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
