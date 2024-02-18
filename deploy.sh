#!/bin/bash
source ./variables.sh "initial"

$terraform init

# Create the image repository in the first account
$terraform apply --auto-approve --target=module.account_a

# Build and push container image to the repository
bash pipeline_step_1_build.sh "initial"

# Now we can create the function and updater role in the second account
$terraform apply --auto-approve
