#!/bin/bash
set -e -x

export CANDIDATE_BUILD_NUMBER=$( cat version/number | sed 's/\.0$//;s/\.0$//' )

echo -e "\n[INFO] Install tools..."
apt-get update
apt install -y software-properties-common

apt-get install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget -y
wget https://www.python.org/ftp/python/3.9.13/Python-3.9.13.tgz
tar -xf Python-3.9.13.tgz
currentdir=$(pwd)
cd Python-3.9.13
./configure --enable-optimizations
make install
cd $currentdir

apt-get -y install python3-pip
pip3 install 'SoftLayer>=5.6.0'
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

echo -e "\n[INFO] Set up softlayer cli login..."
cat <<EOF > ~/.softlayer
[softlayer]
username = ${SL_USERNAME}
api_key = ${SL_API_KEY}
endpoint_url = https://api.softlayer.com/xmlrpc/v3.1/
timeout = 0
EOF

sl_username=${SL_USERNAME}

echo -e "\n[INFO] Get stemcell vhd filename..."
stemcell_name="bosh-stemcell-${CANDIDATE_BUILD_NUMBER}-${IAAS}-esxi-${OS_NAME}-${OS_VERSION}-go_agent"
stemcell_vhd_filename="${stemcell_name}.vhd"

echo -e "\n[INFO] Import private image from COS..."
image_os_code=UBUNTU_18_64
# private_image_name must be fewer than 64 characters
private_image_name=private-image-imported-from-${OS_VERSION}-${CANDIDATE_BUILD_NUMBER}-vhd
private_image_note="Private image imported form COS ${stemcell_vhd_filename}"
public_image_name=public-image-for-light-bosh-stemcell-${OS_VERSION}-${CANDIDATE_BUILD_NUMBER}
public_image_note="Public image for light bosh stemcell ${OS_VERSION} ${CANDIDATE_BUILD_NUMBER}"

cat > import_image_from_cos.py <<EOF
#!/usr/local/bin/python3
import SoftLayer

client = SoftLayer.create_client_from_env(username='${sl_username}',
                                         api_key='${SL_API_KEY}',
                                         endpoint_url='https://api.softlayer.com/rest/v3',
                                         timeout=30)
image_mgr = SoftLayer.ImageManager(client)

response = image_mgr.import_image_from_uri(name='${private_image_name}',
                                           note='${private_image_note}',
                                           uri='cos://${REGION}/${BUCKET}/${stemcell_vhd_filename}',
                                           os_code='${image_os_code}',
                                           ibm_api_key='${COS_SERVICE_ID_KEY}',
                                           cloud_init=False,
                                           byol=False)
with open('resp.txt', 'w') as f:
	f.write(str(response))
EOF

chmod +x import_image_from_cos.py
python3 import_image_from_cos.py

echo -e "\n[INFO] Wait for the private image id to be ready..."
# to fix Python 3 encoding problem
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

id_ok=false
for (( i=1; i<=60; i++ ))
do
  private_image_id=$(slcli image list --name "${private_image_name}" | tail -f | cut -d " " -f 1)
  if [[ ! ${private_image_id} ]]; then
    echo -e "The private image id is not ready yet, waiting 10 more seconds..."
    sleep 10
  else
    echo -e "The private image id is ready"
    id_ok=true
    echo "The image private id is " ${private_image_id}
    break
  fi
done

if [[ ${id_ok} == false ]]; then
  echo -e "The private image id is not ready after 600 seconds, please check vhd file ${stemcell_vhd_filename} in COS"
  exit 1
fi

sl_username=$(echo ${SL_USERNAME} |sed 's/@/%40/g')
#to make working CURL below we need the sed

echo -e "\n[INFO] Wait for private image import to complete..."
import_success=false
for (( i=1; i<=60; i++ ))
do
  transaction_id=$(curl -k -g https://${sl_username}:${SL_API_KEY}@api.softlayer.com/rest/v3.1/SoftLayer_Virtual_Guest_Block_Device_Template_Group/${private_image_id}/getChildren?objectMask=mask[transaction] | awk -F '"transactionId":' '{print $2}' | awk -F ',' '{print $1}')
  if [[ ${transaction_id} != "null" ]]; then
    echo -e "The image import transaction is not completed yet, waiting 10 more seconds..."
    sleep 10
  else
    echo -e "The image import transaction is completed"
    import_success=true
    break
  fi
done

if [[ "${import_success}" = false ]]; then
  echo -e "The image import failed after 600 seconds, please check the private image ${private_image_id} status"
  exit 1
fi

echo -e "\n[INFO] Create public image from private image..."
curl -X POST -d "{
  \"parameters\":
  [
    \"${public_image_name}\",
    \"${public_image_note}\",
    \"${public_image_note}\",
    [
      {
          \"id\":${sl_para_id},
          \"longName\":\"${longName}\",
          \"name\":\"${sl_para_name}\"
      }
    ]
  ]
}" https://${sl_username}:${SL_API_KEY}@api.softlayer.com/rest/v3.1/SoftLayer_Virtual_Guest_Block_Device_Template_Group/${private_image_id}/createPublicArchiveTransaction > "./stemcell-image/stemcell-info.json"

echo -e "\n[INFO] Wait until the convert transaction completes..."
public_image_id=$(cat stemcell-image/stemcell-info.json | sed 's/\.0$//;s/\.0$//')
convert_success=false
for (( i=1; i<=60; i++ ))
do
  size=$(slcli image detail ${public_image_id} | grep total_size | awk '{print $NF}')
  if [[ ${size} == "0" ]]; then
    echo -e "The image conversion transaction is not completed yet, waiting 10 more seconds..."
    sleep 10
  else
    echo -e "The image conversion transaction is completed"
    convert_success=true
    break
  fi
done

if [[ "${convert_success}" = false ]]; then
  echo -e "The image conversion to public failed after 600 seconds, please check image ${public_image_id} status"
  exit 1
fi

