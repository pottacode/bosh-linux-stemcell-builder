#!/bin/bash

(
  set -e -x

  export CANDIDATE_BUILD_NUMBER=$( cat version/number | sed 's/\.0$//;s/\.0$//' )

  cd stemcell

  echo -e "\n Unpacking tgz..."
  tar zxf *.tgz
  tar zxf image

  ls -la

  echo -e "\n Converting vmdk to vhd..."
  stemcell_name="bosh-stemcell-$CANDIDATE_BUILD_NUMBER-$IAAS-esxi-$OS_NAME-$OS_VERSION-go_agent"
  stemcell_vhd_filename="${stemcell_name}.vhd"
  VBoxManage clonehd *.vmdk --format VHD ${stemcell_vhd_filename}

  echo -e "\n Placing object in Softlayer..."
  pip install awscli
  aws configure set aws_access_key_id ${ACCESS_KEY_ID}
  aws configure set aws_secret_access_key ${SECRET_ACCESS_KEY}
  aws --endpoint-url=https://${ENDPOINT} s3 cp ${stemcell_vhd_filename} s3://${BUCKET}/
  aws --endpoint-url=https://${ENDPOINT} s3 ls s3://${BUCKET}/
)