# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.5.0@sha256:4bfa3e2c0164fb103fb9bfd4dc956facce32b6c5d47cc09fcec883ce9535d5ac AS download

ARG TARGETARCH

# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
# https://github.com/kubernetes/kubernetes/releases
ARG KUBECTL_VERSION=v1.29.0
ARG KUBECTL_CHECKSUM=0e03ab096163f61ab610b33f37f55709d3af8e16e4dcc1eb682882ef80f96fd5
ARG KUBECTL_CHECKSUM_ARM=8f7a4bd6bae900a4ddab12bd1399aa652c0d59ea508f39b910e111d248893ff7

# https://github.com/mia-platform/mlp/releases
ARG MLP_VERSION=v1.2.3
ARG MLP_CHECKSUM=6b1b4794bfec9659630b0d5832d3edb36b6832a6b7372eaa3a60bff14d3942ba
ARG MLP_CHECKSUM_ARM=a1e5a10cd92c9f3113c35a69248d5b5ab5cdbd7a6474f0aa90275eb3ee81b4a0

# https://github.com/helm/helm/releases
ARG HELM_VERSION=v3.13.3
ARG HELM_CHECKSUM=bbb6e7c6201458b235f335280f35493950dcd856825ddcfd1d3b40ae757d5c7d
ARG HELM_CHECKSUM_ARM=44aaa094ae24d01e8c36e327e1837fd3377a0f9152626da088384c5bc6d94562

USER root

RUN mkdir -p "/tmp/local/bin"

RUN case "${TARGETARCH}" in \
		'amd64') \
			kubectl_checksum="${KUBECTL_CHECKSUM}"; \
		;; \
		'arm64') \
			kubectl_checksum="${KUBECTL_CHECKSUM_ARM}"; \
	;; \
		*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	curl -fsSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl" -o "/tmp/kubectl" \
	&& echo "${kubectl_checksum} /tmp/kubectl" | sha256sum -c \
	&& install -o "root" -g "root" -m "0755" "/tmp/kubectl" "/tmp/local/bin/kubectl"

RUN case "${TARGETARCH}" in \
		'amd64') \
			mlp_checksum="${MLP_CHECKSUM}"; \
		;; \
		'arm64') \
			mlp_checksum="${MLP_CHECKSUM_ARM}"; \
	;; \
		*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	curl -fsSL "https://github.com/mia-platform/mlp/releases/download/${MLP_VERSION}/mlp-linux-${TARGETARCH}" -o "/tmp/mlp" \
	&& echo "${mlp_checksum} /tmp/mlp" | sha256sum -c \
	&& install -o "root" -g "root" -m "0755" "/tmp/mlp" "/tmp/local/bin/mlp"

RUN case "${TARGETARCH}" in \
		'amd64') \
			helm_checksum="${HELM_CHECKSUM}"; \
		;; \
		'arm64') \
			helm_checksum="${HELM_CHECKSUM_ARM}"; \
	;; \
		*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	curl -fsSL "https://get.helm.sh/helm-${HELM_VERSION}-linux-${TARGETARCH}.tar.gz" -o "/tmp/helm.tar.gz" \
	&& echo "${helm_checksum} /tmp/helm.tar.gz" | sha256sum -c \
	&& tar -xvf "/tmp/helm.tar.gz" --no-same-permissions --no-same-owner -C "/tmp" \
	&& install -o "root" -g "root" -m "0755" "/tmp/linux-${TARGETARCH}/helm" "/tmp/local/bin/helm"

FROM ghcr.io/mia-platform/base-pipeline:1

COPY --from=download /tmp/local /usr/local
