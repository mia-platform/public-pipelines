# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.12.0@sha256:3dfa70a646c5d03ddf0e7c0ff518a5661e95b8bcbc82079f0fb7453a96eaae35 AS download

ARG TARGETARCH

# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
# https://github.com/kubernetes/kubernetes/releases
ARG KUBECTL_VERSION=v1.32.1
ARG KUBECTL_CHECKSUM=e16c80f1a9f94db31063477eb9e61a2e24c1a4eee09ba776b029048f5369db0c
ARG KUBECTL_CHECKSUM_ARM=98206fd83a4fd17f013f8c61c33d0ae8ec3a7c53ec59ef3d6a0a9400862dc5b2

# https://github.com/mia-platform/mlp/releases
ARG MLP_VERSION=v2.0.0
ARG MLP_CHECKSUM=ae28c70851301e97ad9e09d7dc2f205b6fd6659e14641ef6e38eb30c6742809c
ARG MLP_CHECKSUM_ARM=6cea7433f6cb5a28fde08ebaee38cf47b4836e5d8554cd5a6ee444d6c354ede8

# https://github.com/helm/helm/releases
ARG HELM_VERSION=v3.17.0
ARG HELM_CHECKSUM=fb5d12662fde6eeff36ac4ccacbf3abed96b0ee2de07afdde4edb14e613aee24
ARG HELM_CHECKSUM_ARM=c4d4be8e80082b7eaa411e3e231d62cf05d01cddfef59b0d01006a7901e11ee4

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
	curl -fsSL --proto '=https' --tlsv1.2 "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl" -o "/tmp/kubectl" \
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
	curl -fsSL --proto '=https' --tlsv1.2 "https://github.com/mia-platform/mlp/releases/download/${MLP_VERSION}/mlp-linux-${TARGETARCH}" -o "/tmp/mlp" \
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
	curl -fsSL --proto '=https' --tlsv1.2 "https://get.helm.sh/helm-${HELM_VERSION}-linux-${TARGETARCH}.tar.gz" -o "/tmp/helm.tar.gz" \
	&& echo "${helm_checksum} /tmp/helm.tar.gz" | sha256sum -c \
	&& tar -xvf "/tmp/helm.tar.gz" --no-same-permissions --no-same-owner -C "/tmp" \
	&& install -o "root" -g "root" -m "0755" "/tmp/linux-${TARGETARCH}/helm" "/tmp/local/bin/helm"

FROM ghcr.io/mia-platform/base-pipeline:1

COPY --from=download /tmp/local /usr/local
