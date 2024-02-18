set -e
set -u

function assume_role() {
    local -r session_name="$(uuidgen)"
    local -r assume_output="$(aws sts assume-role --role-arn ${1} --role-session-name ${session_name})"
    local -r access_key_id=$(echo "${assume_output}" | jq -r .Credentials.AccessKeyId)
    local -r secret_access=$(echo "${assume_output}" | jq -r .Credentials.SecretAccessKey)
    local -r session_token=$(echo "${assume_output}" | jq -r .Credentials.SessionToken)

    export AWS_ACCESS_KEY_ID="${access_key_id}"
    export AWS_SECRET_ACCESS_KEY="${secret_access}"
    export AWS_SESSION_TOKEN="${session_token}"
}

readonly release="$1"

readonly docker="podman"
readonly terraform="tofu"
readonly tf_output="$(${terraform} output --json)"

readonly region="$(echo "${tf_output}" | jq -r .account_a.value.region)"
readonly ecr_registry="$(echo "${tf_output}" | jq -r .account_a.value.ecr_registry)"
readonly repository_url="$(echo "${tf_output}" | jq -r .account_a.value.repository_url)"

readonly image_url="${repository_url}:${release}"
readonly function_arn="$(echo "${tf_output}" | jq -r .account_b.value.function_arn)"
readonly updater_role_arn="$(echo "${tf_output}" | jq -r .account_b.value.updater_role_arn)"

readonly pipeline_role_arn="$(echo "${tf_output}" | jq -r .pipeline.value.role_arn)"
