#!/bin/bash

set -e -x

stemcell_version=$(cat version/number | sed 's/\.0$//;s/\.0$//')
echo -e "\n[INFO] stemcell-version: ${stemcell_version}"

if [ "$STEMCELL_FORMATS" == 'replace-me' ]; then
  echo -e "\n[INFO] Set stemcell-formats for backward compatibility."
  STEMCELL_FORMATS="softlayer-light-legacy"
fi
echo -e "\n[INFO] stemcell-formats: ${STEMCELL_FORMATS}"

# outputs
output_dir="light-stemcell"
mkdir -p ${output_dir}

echo -e "\n[INFO] Unpacking stemcell raw tgz and copy dev_tools_file_list.txt / packages.txt to target..."
tar zxf stemcell/*.tgz -C stemcell
cp stemcell/dev_tools_file_list.txt ${output_dir}
cp stemcell/packages.txt ${output_dir}

echo -e "\n[INFO] Check if the public image exists..."
sl_username=$(echo ${SL_USERNAME} |sed 's/@/%40/g')
public_image_id=$(cat stemcell-info/stemcell-info.json | sed 's/\.0$//;s/\.0$//')
public_image_uuid=$(curl -k https://${sl_username}:${SL_API_KEY}@api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest_Block_Device_Template_Group/${public_image_id}/getObject.json | jq .globalIdentifier | sed 's/"//g')
sha1_value=$(echo -n ${public_image_id}:${public_image_uuid} | sha1sum | cut -d ' ' -f1)

filter='\{"globalIdentifier":\{"operation":"'${public_image_uuid}'"\}\}'
result=$(curl -s -X GET https://${sl_username}:${SL_API_KEY}@api.softlayer.com/rest/v3.1/SoftLayer_Virtual_Guest_Block_Device_Template_Group/getPublicImages?objectFilter=${filter})
if [[ ${result} == "[]" ]]; then
  echo "Can't find the public image with id (${public_image_id}) uuid (${public_image_uuid}). Please check if it exists"
  exit 1
fi


pushd ${output_dir}

echo -e "[INFO] Compose stemcell.MF"
cat <<EOF > stemcell.MF
name: bosh-softlayer-xen-${OS_NAME}-${OS_VERSION}-go_agent
version: "${stemcell_version}"
bosh_protocol: 1
sha1: ${sha1_value}
operating_system: ${OS_NAME}-${OS_VERSION}
cloud_properties:
  infrastructure: ${IAAS}
  architecture: x86_64
  root_device_name: /dev/xvda
  version: "${stemcell_version}"
  virtual-disk-image-id: ${public_image_id}
  virtual-disk-image-uuid: ${public_image_uuid}
  datacenter-name: ${DATACENTER}
stemcell_formats:
- softlayer-light
EOF

echo "stemcell.MF:"
cat stemcell.MF

echo -e "[INFO] Compress light stemcell tgz file"
touch image
stemcell_filename=light-bosh-stemcell-${stemcell_version}-${IAAS}-${HYPERVISOR}-${OS_NAME}-${OS_VERSION}-go_agent.tgz
tar zcvf ${stemcell_filename} image stemcell.MF packages.txt dev_tools_file_list.txt

popd

echo -e "\n[INFO] Printing stemcell sha1 value..."
checksum="$(sha1sum "./${output_dir}/${stemcell_filename}" | awk '{print $1}')"
echo "$stemcell_filename sha1=$checksum"
