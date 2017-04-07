#!/usr/bin/env bash
if [ -z "$1" ]
then
  echo "Usage: must pass the terraform directory"
  exit 1
fi

export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_DEFAULT_REGION="us-west-1"

cd $1
terraform $2
