# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.11.1@sha256:c1fe1679c34d9784c1b0d1e5f62ac0a79fca01fb6377cdd33e90473c6f9f9a69 AS download

ARG TARGETARCH

# https://www.rust-lang.org/tools/install
ARG RUSTUP_VERSION=1.27.1
ARG RUSTUP_CHECKSUM=6aeece6993e902708983b209d04c0d1dbb14ebb405ddb87def578d41f920f56d
ARG RUSTUP_CHECKSUM_ARM=1cffbf51e63e634c746f741de50649bbbcbd9dbe1de363c9ecef64e278dba2b2

USER root

RUN case "${TARGETARCH}" in \
		'amd64') \
			checksum="${RUSTUP_CHECKSUM}"; \
			arch="x86_64"; \
		;; \
		'arm64') \
			checksum="${RUSTUP_CHECKSUM_ARM}"; \
			arch="aarch64"; \
		;; \
		*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	curl -fsSL --proto '=https' --tlsv1.2 "https://static.rust-lang.org/rustup/archive/${RUSTUP_VERSION}/${arch}-unknown-linux-gnu/rustup-init" -o "/tmp/rustup-init" \
	&& echo "${checksum} /tmp/rustup-init" | sha256sum -c - \
	&& chmod +x /tmp/rustup-init


FROM ghcr.io/mia-platform/base-pipeline:1 AS build

ARG TARGETARCH

ARG DEBIAN_FRONTEND=noninteractive
ARG RUST_VERSION=1.84.1

ENV RUSTUP_HOME="/tmp/local/rustup"
ENV CARGO_HOME="/tmp/local/cargo"

RUN mkdir -p "/tmp/local"

RUN apt-get update && apt-get install --assume-yes --no-install-recommends \
	gcc \
	libc6-dev

COPY --from=download /tmp/rustup-init /tmp/rustup-init

RUN case "${TARGETARCH}" in \
		'amd64') \
			arch="x86_64"; \
		;; \
		'arm64') \
			arch="aarch64"; \
		;; \
		*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
		esac; \
		/tmp/rustup-init -y --no-modify-path --profile minimal --default-toolchain "${RUST_VERSION}" --default-host "${arch}-unknown-linux-gnu" \
		&& ${CARGO_HOME}/bin/rustup component add clippy rustfmt \
		&& ${CARGO_HOME}/bin/cargo install cargo-audit cargo-make cargo-outdated \
		&& sed ${CARGO_HOME}/env -i -e 's|/tmp/local/cargo|/usr/local/cargo|' \
		&& rm -rf ${CARGO_HOME}/registry/*

FROM ghcr.io/mia-platform/base-pipeline:1

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --assume-yes --no-install-recommends \
	gcc \
	libc6-dev \
	&& apt-get autoremove --assume-yes \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=build /tmp/local /usr/local

ENV PATH="/usr/local/cargo/bin:$PATH"
ENV RUSTUP_HOME="/usr/local/rustup"
ENV CARGO_HOME="/usr/local/cargo"
