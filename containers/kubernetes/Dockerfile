# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.18.0@sha256:d94d07ba9e7d6de898b6d96c1a072f6f8266c687af78a74f380087a0addf5d17 AS download

ARG TARGETARCH

# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
# https://github.com/kubernetes/kubernetes/releases
ARG KUBECTL_VERSION=v1.34.3
ARG KUBECTL_CHECKSUM=ab60ca5f0fd60c1eb81b52909e67060e3ba0bd27e55a8ac147cbc2172ff14212
ARG KUBECTL_CHECKSUM_ARM=46913a7aa0327f6cc2e1cc2775d53c4a2af5e52f7fd8dacbfbfd098e757f19e9

# https://github.com/kubernetes-sigs/kustomize/releases
ARG KUSTOMIZE_VERSION=v5.8.0
ARG KUSTOMIZE_CHECKSUM=4dfa8307358dd9284aa4d2b1d5596766a65b93433e8fa3f9f74498941f01c5ef
ARG KUSTOMIZE_CHECKSUM_ARM=a4f48b4c3d4ca97d748943e19169de85a2e86e80bcc09558603e2aa66fb15ce1

# https://github.com/helm/helm/releases
ARG HELM_VERSION=v3.20.0
ARG HELM_CHECKSUM=dbb4c8fc8e19d159d1a63dda8db655f9ffa4aac1b9a6b188b34a40957119b286
ARG HELM_CHECKSUM_ARM=bfb14953295d5324d47ab55f3dfba6da28d46c848978c8fbf412d4271bdc29f1

# https://github.com/mia-platform/mlp/releases
ARG MLP_VERSION=v2.6.0
ARG MLP_CHECKSUM=c35370f43c2168673ced1090572546590eb1d371118054796763a6f7afa3203f
ARG MLP_CHECKSUM_ARM=743fb76a93384650fe0b75b9654c143ad0199d5063eaedc1137d85a1fa577595

# https://github.com/mia-platform/vab/releases
ARG VAB_VERSION=v0.15.0
ARG VAB_CHECKSUM=26302ad11368c33f0b1c9f8fd7980949de8bb0cf86ff13580b6ebe31f6befb65
ARG VAB_CHECKSUM_ARM=ea37bffb7a6c6c79a0c9d62cd4b7df5685aec3d44232c671a1c2fa629571c243

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
	kustomize_checksum="${KUSTOMIZE_CHECKSUM}"; \
	;; \
	'arm64') \
	kustomize_checksum="${KUSTOMIZE_CHECKSUM_ARM}"; \
	;; \
	*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	curl -fsSL --proto '=https' --tlsv1.2 "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_${TARGETARCH}.tar.gz" -o "/tmp/kustomize.tar.gz" \
	&& echo "${kustomize_checksum} /tmp/kustomize.tar.gz" | sha256sum -c \
	&& tar -xvf "/tmp/kustomize.tar.gz" --no-same-permissions --no-same-owner -C "/tmp" \
	&& install -o "root" -g "root" -m "0755" "/tmp/kustomize" "/tmp/local/bin/kustomize"

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
	vab_checksum="${VAB_CHECKSUM}"; \
	;; \
	'arm64') \
	vab_checksum="${VAB_CHECKSUM_ARM}"; \
	;; \
	*) echo >&2 "error: unsupported architecture ($TARGETARCH)"; exit 1; ;; \
	esac; \
	curl -fsSL --proto '=https' --tlsv1.2 "https://github.com/mia-platform/vab/releases/download/${VAB_VERSION}/vab-linux-${TARGETARCH}" -o "/tmp/vab" \
	&& echo "${vab_checksum} /tmp/vab" | sha256sum -c \
	&& install -o "root" -g "root" -m "0755" "/tmp/vab" "/tmp/local/bin/vab"

FROM ghcr.io/mia-platform/base-pipeline:1

COPY --from=download /tmp/local /usr/local
