#!/usr/bin/env bash
if [ -z "$1" ]
then
  echo "Usage: must pass the terraform directory"
  exit 1
fi

export AWS_ACCESS_KEY_ID="AKIAJNX5KB3GJCW3IYPQ"
export AWS_SECRET_ACCESS_KEY="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"
export AWS_DEFAULT_REGION="us-west-1"

cd $1
terraform $2
