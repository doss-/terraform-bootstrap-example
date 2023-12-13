#!/usr/bin/env bash

#
# this script is used for bootstraping the project base infrastructure
#
  
echo -e "DON'T FORGET TO UPDATE backend.tfvars with: \n \
AWS_PROFILE \n \
BUCKET NAME \n \
REGION"
exit 1

if [ -n "$1" ] && [ ! -d $1 ]; then
  target_dir="../../${1}"
fi

# create base infra
terraform -chdir=setup init 
terraform -chdir=setup apply -var-file=../backend.tfvars

if [ -n "$1" ]; then
  cp result-* ${target_dir}
fi
