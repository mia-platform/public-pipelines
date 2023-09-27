# syntax=docker/dockerfile:1
FROM ghcr.io/mia-platform/base-pipeline:1

ARG TARGETARCH

ARG DOCKER_VERSION=24.0.6

ARG BUILDX_VERSION=v0.11.2
ARG BUILDX_CHECKSUM=311568ee69715abc46163fd688e56c77ab0144ff32e116d0f293bfc3470e75b7
ARG BUILDX_CHECKSUM_ARM=565e36085a35bba5104f37365ba796c111338eea1a0902b3a7ff42e2e1248815

ARG ORAS_VERSION=1.1.0
ARG ORAS_CHECKSUM=e09e85323b24ccc8209a1506f142e3d481e6e809018537c6b3db979c891e6ad7
ARG ORAS_CHECKSUM_ARM=e450b081f67f6fda2f16b7046075c67c9a53f3fda92fd20ecc59873b10477ab4

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
