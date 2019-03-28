#!/bin/bash

set -o errexit -o nounset -o pipefail

function check_param() {
  local name=$1
  local value=$(eval echo '$'$name)
  if [ "$value" == 'replace-me' ]; then
    echo -e "\n[ERROR] environment variable $name must be set"
    exit 1
  fi
}

check_param PUBLISHED_BUCKET_NAME
check_param OS_NAME
check_param OS_VERSION

export TASK_DIR=$PWD
export VERSION=$( cat version/number | sed 's/\.0$//;s/\.0$//' )

echo "[INFO] Install dependencies packages"
apt-get update
apt-get install curl -y

tar zxvf stemcell/*.tgz  -C ./
image_id=`grep "virtual-disk-image-id:" stemcell.MF| cut -d ":" -f2 | sed 's/^[ \t]*//g' `
sl_username=`echo $SL_USERNAME |sed 's/@/%40/g'`
result_str=`curl --silent -X POST -d '{"parameters":[ "FORCE",  { "imageTemplateId": "'$image_id'" }] }' https://$sl_username:$SL_API_KEY@api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest/$VM_ID/reloadOperatingSystem.json`
result=`echo $result_str |sed 's/\"//g'`
if [ "$result" != "1" ] ; then
   echo "Reload vm failed"
   exit 1
else
   echo "Reload vm done!"
fi



