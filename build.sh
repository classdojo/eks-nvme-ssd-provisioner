#!/bin/bash

set -e

PLATFORMS="linux/arm64,linux/amd64"

ECR_NAME="classdojo/eks-nvme-ssd-provisioner"
REPO_TAG="$(git rev-parse --short HEAD)"

aws ecr describe-repositories --repository-names "${ECR_NAME}" --no-paginate --output json --no-cli-pager > /dev/null || {
    echo "Creating ECR repo: ${ECR_NAME}"
    aws ecr create-repository \
        --repository-name "${ECR_NAME}" \
        --region us-east-1 \
        --no-paginate --output json --no-cli-pager 
}

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 347708466071.dkr.ecr.us-east-1.amazonaws.com || true
COMPLETE_TAG="347708466071.dkr.ecr.us-east-1.amazonaws.com/${ECR_NAME}:${REPO_TAG}"

docker buildx build \
    --platform "${PLATFORMS}" \
    -t "${COMPLETE_TAG}" \
    --pull \
    --push .

echo -e "\n========> Image now available at: ${COMPLETE_TAG}"