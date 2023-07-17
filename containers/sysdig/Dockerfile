# syntax=docker/dockerfile:1
FROM ghcr.io/mia-platform/base-pipeline:1

ARG TARGETARCH

ARG DOCKER_VERSION=24.0.2

ARG SYSDIG_SCANNER_VERSION=1.5.0
ARG SYSDIG_SCANNER_CHECKSUM=df5b9293571f063eccc4465518adaf0364593a34185336ab2946a538f79856fd
ARG SYSDIG_SCANNER_CHECKSUM_ARM=0a42080f1463a94160c8cd653b9ce49ffef72468ebef7e899fbfb579161712f8

# install docker
RUN arch="$(uname -m)"; \
	wget --compression=auto https://download.docker.com/linux/static/stable/${arch}/docker-${DOCKER_VERSION}.tgz -O /tmp/docker.tgz && \
	tar -xvf /tmp/docker.tgz --no-same-owner -C /tmp/ && \
	mv -v /tmp/docker/docker /usr/local/bin/

# install sysdig-cli-scanner https://docs.sysdig.com/en/docs/installation/sysdig-secure/install-vulnerability-cli-scanner/
RUN wget --compression=auto https://download.sysdig.com/scanning/bin/sysdig-cli-scanner/${SYSDIG_SCANNER_VERSION}/linux/${TARGETARCH}/sysdig-cli-scanner -O /tmp/sysdig-cli-scanner && \
	case "${TARGETARCH}" in \
		'amd64') \
			checksum="${SYSDIG_SCANNER_CHECKSUM}"; \
		;; \
		'arm64') \
			checksum="${SYSDIG_SCANNER_CHECKSUM_ARM}"; \
		;; \
		*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1 ;; \
	esac; \
	echo "${checksum} /tmp/sysdig-cli-scanner" | sha256sum -c - && \
	chmod +x /tmp/sysdig-cli-scanner && \
	mv /tmp/sysdig-cli-scanner /usr/local/bin
