#!/bin/bash
source ./variables.sh "$1"

echo
echo "Assuming pipeline role... "
assume_role "${pipeline_role_arn}"
aws sts get-caller-identity --query Arn

echo
echo "Assumming updater role... "
assume_role "${updater_role_arn}"
aws sts get-caller-identity --query Arn

echo
echo "Updating function image..."
aws lambda update-function-code --image-uri "${image_url}" --function-name "${function_arn}"

echo
echo "Waiting for the update completion..."
aws lambda wait function-updated --function-name "${function_arn}"

echo
echo "Testing the function..."
aws lambda invoke --function-name "${function_arn}" /dev/stdout
