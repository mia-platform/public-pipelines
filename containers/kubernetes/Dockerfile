# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.13.0@sha256:d43bdb28bae0be0998f3be83199bfb2b81e0a30b034b6d7586ce7e05de34c3fd AS download

ARG TARGETARCH

# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
# https://github.com/kubernetes/kubernetes/releases
ARG KUBECTL_VERSION=v1.33.1
ARG KUBECTL_CHECKSUM=5de4e9f2266738fd112b721265a0c1cd7f4e5208b670f811861f699474a100a3
ARG KUBECTL_CHECKSUM_ARM=d595d1a26b7444e0beb122e25750ee4524e74414bbde070b672b423139295ce6

# https://github.com/kubernetes-sigs/kustomize/releases
ARG KUSTOMIZE_VERSION=v5.6.0
ARG KUSTOMIZE_CHECKSUM=54e4031ddc4e7fc59e408da29e7c646e8e57b8088c51b84b3df0864f47b5148f
ARG KUSTOMIZE_CHECKSUM_ARM=ad8ab62d4f6d59a8afda0eec4ba2e5cd2f86bf1afeea4b78d06daac945eb0660

# https://github.com/helm/helm/releases
ARG HELM_VERSION=v3.18.1
ARG HELM_CHECKSUM=b1c7e8e261fd30f34c617282813ecafc63628fcd59a255a9fc51b1fe43394c05
ARG HELM_CHECKSUM_ARM=5ddc8fbd4b17857754a95be799543ceafa5aa9532b05f738ee590a76bb049988

# https://github.com/mia-platform/mlp/releases
ARG MLP_VERSION=v2.0.2
ARG MLP_CHECKSUM=d17c052ce0ec6fbbe104c8ddf3a679665ddce03115b4b30d8c6d511d04e3504d
ARG MLP_CHECKSUM_ARM=27c19a1c40a77656dfe4b9c0a97f44c2f8e58da8a085296cdc06a85f571bc734

# https://github.com/mia-platform/vab/releases
ARG VAB_VERSION=v0.12.1
ARG VAB_CHECKSUM=e708276b2dff19a4e8bdab50b0e71adb1a887a6c9581801cec02dd2c9a6f03aa
ARG VAB_CHECKSUM_ARM=07624a8135243b6b6282b44a56678ef902056b50b9c2e5e53e1343f47e3134c8

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
