#!/bin/bash

set -e
set -u

readonly release="$(date +%s)"

echo
echo "Current identity: "
aws sts get-caller-identity --query Arn

bash pipeline_step_1_build.sh "${release}"
bash pipeline_step_2_update.sh "${release}"
