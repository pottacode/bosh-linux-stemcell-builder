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
apt-get install sshpass -y

# get active transaction curl command
curl_cmd="curl --silent -u $SL_USERNAME:$SL_API_KEY https://api.service.softlayer.com/rest/v3.1/SoftLayer_Virtual_Guest/$VM_ID.json?objectMask=mask%5Bid%2C+activeTransaction%5Bid%2CtransactionStatus.name%5D%5D"

# check if the VM is ready for os-reload (no active transaction)
response=`$curl_cmd`
echo $response
if [[ $response =~ "activeTransaction" ]]
then
    echo "There is active transactions running on the VM. Can't do OS relaod for now."
    exit 1
else
    echo "The VM is ready to do OS reload. Launching OS relaod..."
fi

# do os-reload
tar zxf stemcell/*.tgz  -C ./
image_id=`grep "virtual-disk-image-id:" stemcell.MF| cut -d ":" -f2 | sed 's/^[ \t]*//g' `
sl_username=`echo $SL_USERNAME |sed 's/@/%40/g'`

result_str=`curl --silent -X POST -d '{"parameters":[ "FORCE",  { "imageTemplateId": "'$image_id'" }] }' https://$sl_username:$SL_API_KEY@api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest/$VM_ID/reloadOperatingSystem.json`
result=`echo $result_str |sed 's/\"//g'`
if [ "$result" != "1" ] ; then
   echo "OS reload failed to launch!"
   exit 1
else
   echo "OS reload launched!"
fi

# check if os-reload starts in loop
while true
do
	response=`$curl_cmd`
	echo $response
	if [[ $response =~ "activeTransaction" ]]
	then
        echo "OS reload started!"
        break
	else
        echo "No active transaction yet. Waiting for OS reload to start!"
        sleep 2
	fi
done

# check if os-reload is done in loop
while true
do
	response=`$curl_cmd`
	echo $response
	if [[ $response =~ "activeTransaction" ]]
	then
        sleep 30
	else
        echo "No active transaction. OS reload done!"
        break
	fi
done

# check /var/vcap/bosh/etc/stemcell_version in the reloaded vm $VM_ID
root_pwd=`slcli vs detail --passwords $VM_ID | grep users | awk -F ' ' '{print $4}'`
private_ip=`slcli vs detail --passwords $VM_ID | grep "private_ip" | awk -F ' ' '{print $2}'`
stemcell_version_vm=`sshpass -p $root_pwd ssh -o StrictHostKeychecking=no root@$private_ip "cat /var/vcap/bosh/etc/stemcell_version"`
echo "/var/vcap/bosh/etc/stemcell_version file on VM $VM_ID is $stemcell_version_vm"
stemcell_version_target=`cat stemcell/version`
echo "stemcell_version_target is $stemcell_version_target"
if [[ $stemcell_version_vm == $stemcell_version_target ]]
then
    echo "stemcell_version check on $VM_ID PASSED!"
else
    echo "stemcell_version check on $VM_ID FAILED!"
    exit 1
fi

# show "uname -a"
uname_result=`sshpass -p $root_pwd ssh -o StrictHostKeychecking=no root@$private_ip "uname -a"`
echo "'uname -a' result:"
echo $uname_result