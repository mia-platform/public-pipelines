# syntax=docker/dockerfile:1
FROM ghcr.io/mia-platform/base-pipeline:1

ARG TARGETARCH

ARG DOCKER_VERSION=24.0.5

ARG SYSDIG_SCANNER_VERSION=1.5.1
ARG SYSDIG_SCANNER_CHECKSUM=68d669d78b0fd7ccaf59bdf9476dd911bfc42bda57e793bff65ae079edef095d
ARG SYSDIG_SCANNER_CHECKSUM_ARM=badf7c7a8dfb97bbf326fbd7c42f5f95120fb410924028899fbb4d8579fb3275

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
