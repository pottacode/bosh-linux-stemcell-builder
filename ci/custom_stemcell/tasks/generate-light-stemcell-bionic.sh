#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

echo -e "Set up softlayer cli login"
cat <<EOF > ~/.softlayer
[softlayer]
username = ${SL_USERNAME}
api_key = ${SL_API_KEY}
endpoint_url = https://api.softlayer.com/xmlrpc/v3.1/
timeout = 0
EOF
#echo "nameserver 114.114.114.114" > /etc/resolv.conf
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo -e "\n Get stemcell version..."
stemcell_version=$(cat version/number | sed 's/\.0$//;s/\.0$//')
stemcell_id=`cat stemcell-info/stemcell-info-${stemcell_version}.json`
echo -e "Get UUID of stemcell ${stemcell_id}"
stemcell_uuid=`slcli image detail ${stemcell_id} | grep global_identifier | tr -s [:space:] | cut -d " " -f 2`

# outputs
output_dir="light-stemcell"
mkdir -p ${output_dir}

echo -e "Compose packages.txt and dev_tools_file_list.txt"
tar zxf stemcell/*.tgz -C stemcell

sl_username=$(echo ${SL_USERNAME} |sed 's/@/%40/g')
#to make working CURL below we need the sed

# Create package.txt from "dpkg -l"
apt-get update
apt-get install -y jq
apt-get install -y sshpass
root_pwd=$(echo `curl -s -g -k https://${sl_username}:${SL_API_KEY}@api.softlayer.com/rest/v3.1/SoftLayer_Virtual_Guest/${stemcell_vm_id}/getSoftwareComponents?objectMask=mask[passwords[password]] | jq '.[0].passwords[0].password'` | sed -e 's/"//g')
private_ip=$(echo `curl -s -g -k https://${sl_username}:${SL_API_KEY}@api.softlayer.com/rest/v3.1/SoftLayer_Virtual_Guest/${stemcell_vm_id}/getObject?objectMask=mask[primaryIpAddress] | jq .primaryBackendIpAddress` | sed -e 's/"//g')
sshpass -p $root_pwd ssh -o StrictHostKeychecking=no root@${private_ip} "dpkg -l" > ${output_dir}/packages.txt

cp stemcell/dev_tools_file_list.txt ${output_dir}

pushd ${output_dir}
echo -e "Compose stemcell.MF"
cat <<EOF > stemcell.MF
name: bosh-bluemix-xen-${OS_NAME}-${OS_VERSION}-go_agent
version: "${stemcell_version}"
bosh_protocol: 1
sha1: MTYxMzE1MTplYWNlZDU0Ni04ODU4LTRhZWMtYmE0Yy01NmYxZTgzMjExNGTaOaPuXmtLDTJVv++VYBiQr9gHCQ==
operating_system: ${OS_NAME}-${OS_VERSION}
cloud_properties:
  infrastructure: ${IAAS}
  architecture: x86_64
  root_device_name: /dev/xvda
  version: "${stemcell_version}"
  virtual-disk-image-id: ${stemcell_id}
  virtual-disk-image-uuid: ${stemcell_uuid}
  datacenter-name: lon02
stemcell_formats:
- softlayer-light
EOF

echo -e "Compress light stemcell tgz file"
touch image
stemcell_filename=light-bosh-stemcell-${stemcell_version}-${IAAS}-${HYPERVISOR}-${OS_NAME}-${OS_VERSION}-go_agent.tgz

tar zcvf $stemcell_filename image stemcell.MF packages.txt dev_tools_file_list.txt
checksum="$(sha1sum "${stemcell_filename}" | awk '{print $1}')"

fileUrl=https://s3.us.cloud-object-storage.appdomain.cloud/bluemix-stemcell-version/${stemcell_filename}
echo -e "Stemcell Download URL -> ${fileUrl}"
sha1=`curl -L ${fileUrl} | sha1sum | cut -d " " -f 1`
echo -e "Sha1 hashcode -> $checksum"

popd
