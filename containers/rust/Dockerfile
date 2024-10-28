# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.12.1@sha256:94e9e444bcba979c2ea12e27ae39bee4cd10bc7041a472c4727a558e213744e6 AS download

ARG TARGETARCH

# https://www.rust-lang.org/tools/install
ARG RUSTUP_VERSION=1.28.1
ARG RUSTUP_CHECKSUM=a3339fb004c3d0bb9862ba0bce001861fe5cbde9c10d16591eb3f39ee6cd3e7f
ARG RUSTUP_CHECKSUM_ARM=c64b33db2c6b9385817ec0e49a84bcfe018ed6e328fe755c3c809580cc70ce7a

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
ARG RUST_VERSION=1.85.0

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
	&& rm -rf /var/lib/apt/lists/*

COPY --from=build /tmp/local /usr/local

ENV PATH="/usr/local/cargo/bin:$PATH"
ENV RUSTUP_HOME="/usr/local/rustup"
ENV CARGO_HOME="/usr/local/cargo"
