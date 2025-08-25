# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.15.0@sha256:4026b29997dc7c823b51c164b71e2b51e0fd95cce4601f78202c513d97da2922 AS download

ARG TARGETARCH

# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
# https://github.com/kubernetes/kubernetes/releases
ARG KUBECTL_VERSION=v1.33.4
ARG KUBECTL_CHECKSUM=c2ba72c115d524b72aaee9aab8df8b876e1596889d2f3f27d68405262ce86ca1
ARG KUBECTL_CHECKSUM_ARM=76cd7a2aa59571519b68c3943521404cbce55dafb7d8866f8d0ea2995b396eef

# https://github.com/kubernetes-sigs/kustomize/releases
ARG KUSTOMIZE_VERSION=v5.7.1
ARG KUSTOMIZE_CHECKSUM=ea375e7372f9aa029129d4b2d16c66b7750b7f1213c4f66f910d981c895818d8
ARG KUSTOMIZE_CHECKSUM_ARM=4261a040217df3bd6896597c3986d1465925726e4f22a945304b5233a4dcdbda

# https://github.com/helm/helm/releases
ARG HELM_VERSION=v3.18.6
ARG HELM_CHECKSUM=3f43c0aa57243852dd542493a0f54f1396c0bc8ec7296bbb2c01e802010819ce
ARG HELM_CHECKSUM_ARM=5b8e00b6709caab466cbbb0bc29ee09059b8dc9417991dd04b497530e49b1737

# https://github.com/mia-platform/mlp/releases
ARG MLP_VERSION=v2.1.0
ARG MLP_CHECKSUM=2130148fbf039d18ba5b179df9e227322ed498d25e62644ee1a422e1ac57d141
ARG MLP_CHECKSUM_ARM=0b6f2de97591944a241ee1ee3828df9848f943eba1b58c59eab3edcfdaaf1aff

# https://github.com/mia-platform/vab/releases
ARG VAB_VERSION=v0.13.0
ARG VAB_CHECKSUM=7baa6138fbf7ceca75d37c2ec7df578d288f5f6e266b41859c99ff8278869895
ARG VAB_CHECKSUM_ARM=8e07e9a50826097c93d331ece23c2a7aa0b64b66acaf49c3b42e29417e421ec6

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
