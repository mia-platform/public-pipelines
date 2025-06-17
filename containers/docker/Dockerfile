# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.14.1@sha256:9a1ed35addb45476afa911696297f8e115993df459278ed036182dd2cd22b67b AS download

ARG TARGETARCH

# https://download.docker.com/linux/static/stable/
ARG DOCKER_VERSION=28.2.2

# https://github.com/docker/buildx/releases
ARG BUILDX_VERSION=v0.24.0
ARG BUILDX_CHECKSUM=c41ed17ec05b6ebb50eeb02fb26cce90f16cd260b8d26ce73963428c6b2d6508
ARG BUILDX_CHECKSUM_ARM=ad33819d085a635e3b4400a412bd2b4e943bfbc830366d78f50579bae48f8053

# https://github.com/docker/compose/releases
ARG DOCKER_COMPOSE_VERSION=v2.37.1
ARG DOCKER_COMPOSE_CHECKSUM=6777247eb2947c48b46b1fc96602ac17e140fbac84e1043e6384a6c755fc6769
ARG DOCKER_COMPOSE_CHECKSUM_ARM=36dfcc81ffff0ec2a76abaa4b66edf01d2db0d7f3fda342a26525eb72e4e9a80

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
