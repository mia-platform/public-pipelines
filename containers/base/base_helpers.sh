#!/usr/bin/env bash

setup_gcp_access_token() {
	local jwt="${1}"
	local audience="${2}"
	local service_account="${3}"
	local output_path="${4}"

	local jwt_path="${output_path}/.gitlab_jwt"
	local credentials_path="${output_path}/.gcp_wif_config"

	printf "%s" "${jwt}" > "${jwt_path}"

	jq -nS --arg audience "${audience}" --arg jwtPath "${jwt_path}" '{
	type: "external_account",
	audience: $audience,
	subject_token_type: "urn:ietf:params:oauth:token-type:jwt",
	token_url: "https://sts.googleapis.com/v1/token",
	credential_source: {
		file: $jwtPath
	},
	}' | jq -S --arg serviceaccount "${service_account}" \
	'if $serviceaccount != "" then
		.service_account_impersonation_url="https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/\($serviceaccount):generateAccessToken"
	else
		.
	end
	' > "${credentials_path}"

	echo "${credentials_path}"
}
