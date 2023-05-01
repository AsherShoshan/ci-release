#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

CLOUD_PROVIDER_REGION=${LEASED_RESOURCE}

trap 'CHILDREN=$(jobs -p); if test -n "${CHILDREN}"; then kill ${CHILDREN} && wait; fi' TERM

# Configure aws
AWSCRED="${CLUSTER_PROFILE_DIR}/.awscred"
if [[ -f "${AWSCRED}" ]]; then
  export AWS_SHARED_CREDENTIALS_FILE="${AWSCRED}"
  export AWS_DEFAULT_REGION="${CLOUD_PROVIDER_REGION}"
else
  echo "Did not find compatible cloud provider cluster_profile"
  exit 1
fi

pushd "${SHARED_DIR}/terraform/account-roles"

terraform destroy -auto-approve

popd
