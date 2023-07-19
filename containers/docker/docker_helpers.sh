#!/usr/bin/env bash

docker_buildx_ctx_name='pipelines'
docker_builder_name='pipelines'

docker_login() {
	local username="${1}"
	local password="${2}"
	local server="${3}"
	echo "${password}" | docker login --username "${username}" --password-stdin "${server}"
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
