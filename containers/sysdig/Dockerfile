# syntax=docker/dockerfile:1
FROM ghcr.io/mia-platform/base-pipeline:1

ARG TARGETARCH

ARG DOCKER_VERSION=24.0.7

ARG ORAS_VERSION=1.1.0
ARG ORAS_CHECKSUM=e09e85323b24ccc8209a1506f142e3d481e6e809018537c6b3db979c891e6ad7
ARG ORAS_CHECKSUM_ARM=e450b081f67f6fda2f16b7046075c67c9a53f3fda92fd20ecc59873b10477ab4

ARG SYSDIG_SCANNER_VERSION=1.6.1
ARG SYSDIG_SCANNER_CHECKSUM=e94d9b10a04f98bd1821c5c51f975c804a894a9dd73017d9e8f6d912f7be297d
ARG SYSDIG_SCANNER_CHECKSUM_ARM=a66931454e87f44d8b85058c989efae178a8374ad5764777c3222f3d68e00347

# install docker
RUN arch="$(uname -m)"; \
	wget --compression=auto https://download.docker.com/linux/static/stable/${arch}/docker-${DOCKER_VERSION}.tgz -O /tmp/docker.tgz && \
	tar -xvf /tmp/docker.tgz --no-same-owner -C /tmp/ && \
	mv -v /tmp/docker/docker /usr/local/bin/

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
