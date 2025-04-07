# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.13.0@sha256:d43bdb28bae0be0998f3be83199bfb2b81e0a30b034b6d7586ce7e05de34c3fd AS download

ARG TARGETARCH

# https://docs.sysdig.com/en/docs/installation/sysdig-secure/install-vulnerability-cli-scanner/
ARG SYSDIG_SCANNER_VERSION=1.22.0
ARG SYSDIG_SCANNER_CHECKSUM=a866d046252fa329f151e6129a3af3e6bf5bba7b617264160f32ed4ea3eee085
ARG SYSDIG_SCANNER_CHECKSUM_ARM=6df6391513d4eeb115374a3f9dfdfdabca853fbce07dfa045f588f5db676da9c

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
