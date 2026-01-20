# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.18.0@sha256:d94d07ba9e7d6de898b6d96c1a072f6f8266c687af78a74f380087a0addf5d17 AS download

ARG TARGETARCH

# https://docs.sysdig.com/en/docs/installation/sysdig-secure/install-vulnerability-cli-scanner/
ARG SYSDIG_SCANNER_VERSION=1.24.2
ARG SYSDIG_SCANNER_CHECKSUM=1eb92099d20482ae5f06db5908ed98d0b7208ad993ca5c018c450203432fa83b
ARG SYSDIG_SCANNER_CHECKSUM_ARM=02cc8cdac72c2ad42a1728196eb857424cf5744ecf5f5fa74f5fa09267e665cb

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
