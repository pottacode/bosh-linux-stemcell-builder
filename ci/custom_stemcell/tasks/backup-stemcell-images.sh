#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

apt-get update
apt-get install sshpass -y
echo -e "Set up softlayer cli login"
cat <<EOF > ~/.softlayer
[softlayer]
username = ${SL_USERNAME}
api_key = ${SL_API_KEY}
endpoint_url = https://api.softlayer.com/xmlrpc/v3.1/
timeout = 0
EOF
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# get /var/vcap/bosh/etc/stemcell_version in the target VM
root_pwd=`slcli vs detail --passwords ${stemcell_vm_id} | grep users | awk -F ' ' '{print $4}'`
private_ip=`slcli vs detail --passwords ${stemcell_vm_id} | grep "private_ip" | awk -F ' ' '{print $2}'`
stemcell_version=`sshpass -p $root_pwd ssh -o StrictHostKeychecking=no root@$private_ip "cat /var/vcap/bosh/etc/stemcell_version"`
echo "/var/vcap/bosh/etc/stemcell_version file on VM ${stemcell_vm_id} is $stemcell_version"

private_image_name="backup-private-image-for-custom-bosh-stemcell-${stemcell_version}"
public_image_name="backup-public-image-for-custom-bosh-stemcell-${stemcell_version}"

echo -e "Capture the VM ${stemcell_vm_id} to a private image for backup"
if [ `slcli image list | grep ${private_image_name} | wc -l` -gt 1 ]; then
  echo -e "There are more than 1 images with name ${private_image_name} exist. Please check. Exiting..."
  exit 1
fi

if [ `slcli image list | grep ${private_image_name} | wc -l` -eq 1 ]; then
  echo -e "There is already 1 image with name ${private_image_name} exists. Use it directly..."
else
  echo -e "There is no image with name ${private_image_name} exists. Capture private image from VM ${stemcell_vm_id}..."
  slcli vs capture -n ${private_image_name} ${stemcell_vm_id}
  if [ $? -ne 0 ]; then
    echo -e "The image capture failed, exiting..."
    exit 1
  fi
  sleep 60
fi

private_image_id=`slcli image list --name ${private_image_name} | tail -f | cut -d " " -f 1`
echo "The backup private image id is ${private_image_id}"

capture_success=false
for (( i=1; i<=60; i++ ))
do
  size=`slcli image detail ${private_image_id} | grep disk_space | awk '{print $NF}'`
  if [ ${size} -eq 0 ]; then
    echo -e "The image capture transaction is not completed yet, waiting 10 more seconds..."
    sleep 10
  else
    echo -e "The image capture transaction is completed"
    capture_success=true
    break
  fi
done

if [ "${capture_success}" = false ]; then
  echo -e "The image capture failed after 600 seconds, please check VM ${stemcell_vm_id} status"
  exit 1
fi

sleep 120

echo -e "Convert the backup private image ${private_image_id} to a public image"
sl_username=`echo ${SL_USERNAME} |sed 's/@/%40/g'`

curl -X POST -d "{
  \"parameters\":
  [
    \"${public_image_name}\",
    \"${public_image_name}\",
    \"${public_image_name}\",
    [
      {
          \"id\":${sl_para_id},
          \"longName\":\"${longName}\",
          \"name\":\"${sl_para_name}\"
      }
    ]
  ]
}" https://$sl_username:${SL_API_KEY}@api.softlayer.com/rest/v3.1/SoftLayer_Virtual_Guest_Block_Device_Template_Group/${private_image_id}/createPublicArchiveTransaction >> stemcell-image/stemcell-info-${stemcell_version}.json

sleep 20
public_image_id=$(cat stemcell-image/stemcell-info-${stemcell_version}.json | sed 's/\.0$//;s/\.0$//')
convert_success=false
for (( i=1; i<=60; i++ ))
do
  size=`slcli image detail ${public_image_id} | grep disk_space | awk '{print $NF}'`
  if [ ${size} -eq 0 ]; then
    echo -e "The image conversion transaction is not completed yet, waiting 10 more seconds..."
    sleep 10
  else
    echo -e "The image conversion transaction is completed"
    convert_success=true
    break
  fi
done

if [ "${convert_success}" = false ]; then
  echo -e "The image conversion to public failed after 600 seconds, please check image ${public_image_id} status"
  exit 1
fi

echo -e "Enable HVM mode for the public stemcell ${public_image_id}"
hvm_enabled=`curl -sk https://$sl_username:${SL_API_KEY}@api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest_Block_Device_Template_Group/${public_image_id}/setBootMode/HVM.json`
if [ "${hvm_enabled}" != true ]; then
  echo -e "Enabling HVM mode on the stemcell ${public_image_id} failed"
  exit 1
fi

echo -e "All images for stemcell ${stemcell_version}"
slcli image list --name *${stemcell_version}*
