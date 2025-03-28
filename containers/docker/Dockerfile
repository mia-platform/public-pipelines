# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.12.1@sha256:94e9e444bcba979c2ea12e27ae39bee4cd10bc7041a472c4727a558e213744e6 AS download

ARG TARGETARCH

# https://download.docker.com/linux/static/stable/
ARG DOCKER_VERSION=28.0.4

# https://github.com/docker/buildx/releases
ARG BUILDX_VERSION=v0.22.0
ARG BUILDX_CHECKSUM=805195386fba0cea5a1487cf0d47da82a145ea0a792bd3fb477583e2dbcdcc2f
ARG BUILDX_CHECKSUM_ARM=6e9e455b5ec1c7ac708f2640a86c5cecce38c72e48acff6cb219dfdfa2dda781

# https://github.com/docker/compose/releases
ARG DOCKER_COMPOSE_VERSION=v2.34.0
ARG DOCKER_COMPOSE_CHECKSUM=94a416c6f2836a0a1ba5eb3feb00f2e700a9d98311f062c4c61494ccbf3cd457
ARG DOCKER_COMPOSE_CHECKSUM_ARM=cd1ef5eda1119edb9314c0224bac97cee14a9c31909a0f7aa0ddfe266e08adaa

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
