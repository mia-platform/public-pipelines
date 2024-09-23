#!/usr/bin/env bash

setup_gcp_access_token() {
	local jwt="${1}"
	local audience="${2}"
	local service_account="${3}"
	local output_path="${4}"

	local jwt_path="${output_path}/.gitlab_jwt"
	local credentials_path="${output_path}/.gcp_wif_config"

	printf "%s" "${jwt}" > "${jwt_path}"

	cat > "${credentials_path}" << EOL
{
	"type": "external_account",
	"audience": "${audience}",
	"subject_token_type": "urn:ietf:params:oauth:token-type:jwt",
	"token_url": "https://sts.googleapis.com/v1/token",
	"credential_source": {
		"file": "${jwt_path}"
	},
	"service_account_impersonation_url": "https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/${service_account}:generateAccessToken"
}
EOL

	return "${credentials_path}"
}
