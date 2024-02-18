#!/bin/bash
source ./variables.sh "$1"

echo
echo "Building image..."
$docker build --build-arg=build="${release}" --tag "${image_url}" image/

echo
echo "Assuming pipeline role... "
assume_role "${pipeline_role_arn}"
aws sts get-caller-identity --query Arn

echo
echo "Logging in to ECR..."
aws ecr --region "${region}" get-login-password \
| $docker login --verbose --username AWS --password-stdin "${ecr_registry}"

echo
echo "Pushing image to repository..."
$docker push "${image_url}"
