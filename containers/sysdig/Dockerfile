# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.20.0@sha256:b3f1fb2a51d923260350d21b8654bbc607164a987e2f7c84a0ac199a67df812a AS download

ARG TARGETARCH

# https://docs.sysdig.com/en/docs/installation/sysdig-secure/install-vulnerability-cli-scanner/
ARG SYSDIG_SCANNER_VERSION=1.25.1
ARG SYSDIG_SCANNER_CHECKSUM=420d34248798a463dc81df6395bc9f3ab925595aec78c30bc2fe61c3ced13ffd
ARG SYSDIG_SCANNER_CHECKSUM_ARM=181a0d4dd4a877f20e7ec0b3602a94f432f38f62c48d75308a0ea08cc6c2ad8b

USER root

RUN mkdir -p "/tmp/local/bin"

RUN case "${TARGETARCH}" in \
	'amd64') \
	checksum="${SYSDIG_SCANNER_CHECKSUM}"; \
	;; \
	'arm64') \
	checksum="${SYSDIG_SCANNER_CHECKSUM_ARM}"; \
	;; \
	*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1 ;; \
	esac; \
	curl -fsSL --proto '=https' --tlsv1.2 "https://download.sysdig.com/scanning/bin/sysdig-cli-scanner/${SYSDIG_SCANNER_VERSION}/linux/${TARGETARCH}/sysdig-cli-scanner" -o "/tmp/sysdig-cli-scanner" \
	&& echo "${checksum} /tmp/sysdig-cli-scanner" | sha256sum -c \
	&& install -o "root" -g "root" -m "0755" "/tmp/sysdig-cli-scanner" "/tmp/local/bin/sysdig-cli-scanner"

FROM ghcr.io/mia-platform/base-pipeline:1

COPY --from=download /tmp/local /usr/local
