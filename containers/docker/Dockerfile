# syntax=docker/dockerfile:1
FROM ghcr.io/mia-platform/base-pipeline:1

ARG TARGETARCH

ARG DOCKER_VERSION=24.0.5

ARG BUILDX_VERSION=v0.11.2
ARG BUILDX_CHECKSUM=311568ee69715abc46163fd688e56c77ab0144ff32e116d0f293bfc3470e75b7
ARG BUILDX_CHECKSUM_ARM=565e36085a35bba5104f37365ba796c111338eea1a0902b3a7ff42e2e1248815

ARG ORAS_VERSION=1.0.1
ARG ORAS_CHECKSUM=6b51b87360d373dd3c19b91d2627d2efd320513380a878b6f06702f72fe8c5ab
ARG ORAS_CHECKSUM_ARM=352a5b21d5840418c7710fa55db9881d46a4c3e2c0fdb14672f9df38ba66dd3d

ENV DOCKER_BUILDKIT=1

# install docker
RUN arch="$(uname -m)"; \
	wget --compression=auto https://download.docker.com/linux/static/stable/${arch}/docker-${DOCKER_VERSION}.tgz -O /tmp/docker.tgz && \
	tar -xvf /tmp/docker.tgz --no-same-owner -C /tmp/ && \
	mv -v /tmp/docker/docker /usr/local/bin/

# install docker-buildx
RUN mkdir -p /usr/local/lib/docker/cli-plugins && \
	wget --compression=auto https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.linux-${TARGETARCH} -O /tmp/docker-buildx && \
	case "${TARGETARCH}" in \
		'amd64') \
			checksum="${BUILDX_CHECKSUM}"; \
		;; \
		'arm64') \
			checksum="${BUILDX_CHECKSUM_ARM}"; \
		;; \
		*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	echo "${checksum} /tmp/docker-buildx" | sha256sum -c - && \
	chmod +x /tmp/docker-buildx && \
	mv /tmp/docker-buildx /usr/local/lib/docker/cli-plugins && \
	rm -rf /tmp/* && \
	mkdir -p /certs/client && \
	chmod 1777 /certs /certs/client

# install ORAS
RUN wget --compression=auto "https://github.com/oras-project/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_linux_${TARGETARCH}.tar.gz" -O /tmp/oras.tar.gz && \
	case "${TARGETARCH}" in \
		'amd64') \
			checksum="${ORAS_CHECKSUM}"; \
		;; \
		'arm64') \
			checksum="${ORAS_CHECKSUM_ARM}"; \
		;; \
		*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	echo "${checksum} /tmp/oras.tar.gz" | sha256sum -c - && \
	mkdir -p /tmp/oras-install/ && \
	tar -zxf /tmp/oras.tar.gz -C /tmp/oras-install/ && \
	mv /tmp/oras-install/oras /usr/local/bin/ && \
	rm -rf /tmp/oras.tar.gz /tmp/oras-install

COPY ./docker_helpers.sh /usr/local/lib
