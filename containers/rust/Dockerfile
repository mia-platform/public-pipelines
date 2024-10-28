# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.18.0@sha256:d94d07ba9e7d6de898b6d96c1a072f6f8266c687af78a74f380087a0addf5d17 AS download

ARG TARGETARCH

# https://rust-lang.github.io/rustup/installation/other.html#manual-installation
# https://github.com/rust-lang/rustup/tags
ARG RUSTUP_VERSION=1.28.2
ARG RUSTUP_CHECKSUM=20a06e644b0d9bd2fbdbfd52d42540bdde820ea7df86e92e533c073da0cdd43c
ARG RUSTUP_CHECKSUM_ARM=e3853c5a252fca15252d07cb23a1bdd9377a8c6f3efa01531109281ae47f841c

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

# https://github.com/rust-lang/rust/releases
ARG DEBIAN_FRONTEND=noninteractive
ARG RUST_VERSION=1.92.0

ENV RUSTUP_HOME="/tmp/local/rustup"
ENV CARGO_HOME="/tmp/local/cargo"

RUN mkdir -p "/tmp/local"

RUN apt-get update && apt-get install --assume-yes --no-install-recommends \
	gcc \
	libc6-dev \
	libssl-dev \
	pkg-config

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
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=build /tmp/local /usr/local

ENV PATH="/usr/local/cargo/bin:$PATH"
ENV RUSTUP_HOME="/usr/local/rustup"
ENV CARGO_HOME="/usr/local/cargo"
