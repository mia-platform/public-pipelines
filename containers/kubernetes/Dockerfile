# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.6.0@sha256:c3b8bee303c6c6beed656cfc921218c529d65aa61114eb9e27c62047a1271b9b AS download

ARG TARGETARCH

# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
# https://github.com/kubernetes/kubernetes/releases
ARG KUBECTL_VERSION=v1.29.1
ARG KUBECTL_CHECKSUM=69ab3a931e826bf7ac14d38ba7ca637d66a6fcb1ca0e3333a2cafdf15482af9f
ARG KUBECTL_CHECKSUM_ARM=96d6dc7b2bdcd344ce58d17631c452225de5bbf59b83fd3c89c33c6298fb5d8b

# https://github.com/mia-platform/mlp/releases
ARG MLP_VERSION=v1.2.3
ARG MLP_CHECKSUM=6b1b4794bfec9659630b0d5832d3edb36b6832a6b7372eaa3a60bff14d3942ba
ARG MLP_CHECKSUM_ARM=a1e5a10cd92c9f3113c35a69248d5b5ab5cdbd7a6474f0aa90275eb3ee81b4a0

# https://github.com/helm/helm/releases
ARG HELM_VERSION=v3.14.0
ARG HELM_CHECKSUM=f43e1c3387de24547506ab05d24e5309c0ce0b228c23bd8aa64e9ec4b8206651
ARG HELM_CHECKSUM_ARM=b29e61674731b15f6ad3d1a3118a99d3cc2ab25a911aad1b8ac8c72d5a9d2952

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
