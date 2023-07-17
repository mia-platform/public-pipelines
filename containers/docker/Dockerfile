# syntax=docker/dockerfile:1
FROM ghr.io/mia-platform/base-pipeline:1

ARG TARGETARCH

ARG DOCKER_VERSION=24.0.2

ARG BUILDX_VERSION=v0.11.1
ARG BUILDX_CHECKSUM=34927047282ef9052f57809fe94783b2dc0ab556fdd60c2c0b7f4e6e5f05a53b
ARG BUILDX_CHECKSUM_ARM=1649de43c6477eb8bf615f0817932e69e500ce530422bed47c9f3a689baeb788

ARG ORAS_VERSION=1.0.0
ARG ORAS_CHECKSUM=8533c9ea1e5a0d5eb1dfc5094c0e8ef106d15462f8a119077548f88937ed2133
ARG ORAS_CHECKSUM_ARM=332ba74c043ed590ab0fb61656e6d274243e915cb150d48be4ad64ed591dcc84

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
