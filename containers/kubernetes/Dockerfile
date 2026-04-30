# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.20.0@sha256:b3f1fb2a51d923260350d21b8654bbc607164a987e2f7c84a0ac199a67df812a AS download

ARG TARGETARCH

# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
# https://github.com/kubernetes/kubernetes/releases
ARG KUBECTL_VERSION=v1.35.1
ARG KUBECTL_CHECKSUM=36e2f4ac66259232341dd7866952d64a958846470f6a9a6a813b9117bd965207
ARG KUBECTL_CHECKSUM_ARM=706256e21a4e9192ee62d1a007ac0bfcff2b0b26e92cc7baad487a6a5d08ff82

# https://github.com/kubernetes-sigs/kustomize/releases
ARG KUSTOMIZE_VERSION=v5.8.1
ARG KUSTOMIZE_CHECKSUM=029a7f0f4e1932c52a0476cf02a0fd855c0bb85694b82c338fc648dcb53a819d
ARG KUSTOMIZE_CHECKSUM_ARM=0953ea3e476f66d6ddfcd911d750f5167b9365aa9491b2326398e289fef2c142

# the 4.x version will be available only from the 1.35 release
# https://github.com/helm/helm/releases
ARG HELM_VERSION=v4.1.1
ARG HELM_CHECKSUM=5d4c7623283e6dfb1971957f4b755468ab64917066a8567dd50464af298f4031
ARG HELM_CHECKSUM_ARM=02a5fb7742469d2d132e24cb7c3f52885894043576588c6788b6813297629edd

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
