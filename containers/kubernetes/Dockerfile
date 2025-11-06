# syntax=docker/dockerfile:1
FROM docker.io/curlimages/curl:8.17.0@sha256:1e809b44e4cdf8a64a1bfe37875d4758a39454d686c2ff3c4a0fbeda93aae519 AS download

ARG TARGETARCH

# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
# https://github.com/kubernetes/kubernetes/releases
ARG KUBECTL_VERSION=v1.34.1
ARG KUBECTL_CHECKSUM=7721f265e18709862655affba5343e85e1980639395d5754473dafaadcaa69e3
ARG KUBECTL_CHECKSUM_ARM=420e6110e3ba7ee5a3927b5af868d18df17aae36b720529ffa4e9e945aa95450

# https://github.com/kubernetes-sigs/kustomize/releases
ARG KUSTOMIZE_VERSION=v5.7.1
ARG KUSTOMIZE_CHECKSUM=ea375e7372f9aa029129d4b2d16c66b7750b7f1213c4f66f910d981c895818d8
ARG KUSTOMIZE_CHECKSUM_ARM=4261a040217df3bd6896597c3986d1465925726e4f22a945304b5233a4dcdbda

# https://github.com/helm/helm/releases
ARG HELM_VERSION=v3.19.0
ARG HELM_CHECKSUM=a7f81ce08007091b86d8bd696eb4d86b8d0f2e1b9f6c714be62f82f96a594496
ARG HELM_CHECKSUM_ARM=440cf7add0aee27ebc93fada965523c1dc2e0ab340d4348da2215737fc0d76ad

# https://github.com/mia-platform/mlp/releases
ARG MLP_VERSION=v2.5.0
ARG MLP_CHECKSUM=f359b63655f785917ee7113c8e9fa1957db7ab9b9a98520a6ce8ba1f9c929bbc
ARG MLP_CHECKSUM_ARM=02524e67db98aa6144b846fbaf0d374cda9fb8e255398916d0d46c6f20df9e69

# https://github.com/mia-platform/vab/releases
ARG VAB_VERSION=v0.14.0
ARG VAB_CHECKSUM=a6634776579b5dadfdae7ea8c4f7932b133d4ff26215d43b9517a1bc522ce8df
ARG VAB_CHECKSUM_ARM=3ffcff145a15bfba485b49d88e7d1375c35ed724298e660c9bfae7f8a050c0fe

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
