# syntax=docker/dockerfile:1
FROM ghcr.io/mia-platform/base-pipeline:1

ARG TARGETARCH

ARG DOCKER_VERSION=24.0.7

ARG SYSDIG_SCANNER_VERSION=1.6.1
ARG SYSDIG_SCANNER_CHECKSUM=e94d9b10a04f98bd1821c5c51f975c804a894a9dd73017d9e8f6d912f7be297d
ARG SYSDIG_SCANNER_CHECKSUM_ARM=a66931454e87f44d8b85058c989efae178a8374ad5764777c3222f3d68e00347

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
