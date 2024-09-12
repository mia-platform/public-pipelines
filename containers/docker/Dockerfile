# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.10.0@sha256:a3838a5cf24fe940ec63e98fc37ce1dbe1d43286dc2b803c5bc5e9f067c7ad6d AS download

ARG TARGETARCH

# https://download.docker.com/linux/static/stable/
ARG DOCKER_VERSION=27.2.1

# https://github.com/docker/buildx/releases
ARG BUILDX_VERSION=v0.17.0
ARG BUILDX_CHECKSUM=6c65b3a80fd65312ed4949b76d10077c304ea013e78251a91cb0990562ee82a6
ARG BUILDX_CHECKSUM_ARM=8a971c4c9019f646fe9ac73c7e1cc3593a1246d43ddd9da24c588d1d93ca4c4e

# https://github.com/oras-project/oras/releases
ARG ORAS_VERSION=1.2.0
ARG ORAS_CHECKSUM=5b3f1cbb86d869eee68120b9b45b9be983f3738442f87ee5f06b00edd0bab336
ARG ORAS_CHECKSUM_ARM=27df680a39fc2fcedc549cb737891623bc696c9a92a03fd341e9356a35836bae

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
