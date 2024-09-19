#!/usr/bin/env bash

setup_gcp_access_token() {
	local jwt_path="${2}"
	local credentials_path="${3}"
	local project_number="${4}"
	local pool_id="${5}"
	local provider_id="${6}"
	local service_account="${7}"

	cat > "${credentials_path}" << EOL
{
	"type": "external_account",
	"audience": "//iam.googleapis.com/projects/${project_number}/locations/global/workloadIdentityPools/${pool_id}/providers/${provider_id}",
	"subject_token_type": "urn:ietf:params:oauth:token-type:jwt",
	"token_url": "https://sts.googleapis.com/v1/token",
	"credential_source": {
		"file": "${jwt_path}"
	},
	"service_account_impersonation_url": "https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/${service_account}:generateAccessToken"
}
EOL
}
