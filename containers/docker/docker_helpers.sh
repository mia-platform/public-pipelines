#!/usr/bin/env bash

docker_buildx_ctx_name='pipelines'
docker_builder_name='pipelines'

docker_login() {
	local username="${1}"
	local password="${2}"
	local server="${3}"
	echo "${password}" | docker login --username "${username}" --password-stdin "${server}"
}

docker_build() {
	local CONTEXT_PATH="${1}"
	local FILE_PATH="${2}"
	local OUTPUT="${3}"
	local PLATFORMS="${4}"
	local IMAGE_TAG="${5}"
	local COMMIT_SHA="${6}"
	local VERSION="${7}"
	local ADDITIONAL_FLAGS="${8}"

	IFS=$'\n'
	docker buildx build "${CONTEXT_PATH}" --file="${FILE_PATH}" --output="${OUTPUT}" --platform="${PLATFORMS}" \
		--tag="${IMAGE_TAG}" --build-arg="COMMIT_SHA=${COMMIT_SHA}" --build-arg="VERSION=${VERSION}" \
		--provenance="false" ${ADDITIONAL_FLAGS}
}

docker_retag_image() {
	local image_to_retag="${1}"
	local retagged_image="${2}"
	local manifest_path=/tmp/manifest.json

	oras manifest fetch --pretty "${image_to_retag}" --output "${manifest_path}"
	oras manifest delete --force "${image_to_retag}"
	oras manifest push --verbose "${retagged_image}" "${manifest_path}"
	rm -fr "${manifest_path}"
}

docker_create_sbom_and_sign_image() {
	local image="${1}"

	syft packages "${image}" -o spdx-json > docker-image-sbom.spdx.json
	cosign attach sbom --sbom docker-image-sbom.spdx.json "${image}"
	image_digest=$(oras manifest fetch --descriptor "${image}" --pretty | jq -r '.digest')

	if [[ -n "${COSIGN_PRIVATE_KEY}" ]]; then
		cosign sign --key "${COSIGN_PRIVATE_KEY}" --recursive --yes "${image}"@"${image_digest}"
	elif [[ -n "${SIGSTORE_ID_TOKEN}" ]]; then
		cosign sign --recursive --yes "${image}"@"${image_digest}"
	else
		echo "no key found: skipping image signing"
	fi
}

setup_docker_context() {
	# to avoid weird situation where the context or builder are not
	# properly deleted between runs we ensure to clean them up
	cleanup_docker_context || true

	# In order for `docker buildx create` to work, we need to replace DOCKER_HOST with a Docker context.
	# Otherwise, we get the following error:
	# > could not create a builder instance with TLS data loaded from environment.
	local docker="host=${DOCKER_HOST:-unix:///var/run/docker.sock}"
	if [ -n "${DOCKER_CERT_PATH}" ]; then
		docker="host=${DOCKER_HOST},ca=${DOCKER_CERT_PATH}/ca.pem,cert=${DOCKER_CERT_PATH}/cert.pem,key=${DOCKER_CERT_PATH}/key.pem"
	fi
	docker context create "${docker_buildx_ctx_name}" \
		--default-stack-orchestrator=swarm \
		--description "Pipelines buildx Docker context" \
		--docker "${docker}"

	docker buildx create --use --name "${docker_builder_name}" "${docker_buildx_ctx_name}"
}

cleanup_docker_context() {
	set +e
	docker buildx rm "${docker_builder_name}" >/dev/null 2>&1
	docker context rm -f "${docker_buildx_ctx_name}" >/dev/null 2>&1
	set -e
}
