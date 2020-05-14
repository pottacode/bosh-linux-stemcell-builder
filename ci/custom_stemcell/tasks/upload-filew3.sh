#!/bin/bash

set -o errexit -o nounset -o pipefail
output_dir="version"
mkdir -p ${output_dir}

[ -f stemcell/version ] || exit 1
custom_version=$(cat stemcell/version)
export VERSION=$custom_version
stemcell=$(realpath *stemcell/*.tgz)

echo -e "Check if the stemcell ${VERSION} already exists on file.w3.ibm.com"
curl http://file.w3.bluemix.net/releases/light-bosh-stemcell/${VERSION}/ | grep "404 Not Found"
if [[ $? != 0 ]]; then
  echo -e "The stemcell ${VERSION} already exists at http://file.w3.bluemix.net/releases/light-bosh-stemcell/${VERSION}, exiting..."
  exit 1
fi

mkdir -p light-bosh-stecmcell/publish/${VERSION}
echo '-----BEGIN RSA PRIVATE KEY-----' >light-bosh-stecmcell/light-bosh-stecmcell.pem
echo $FILE_W3_STEMCELL_PEM >> light-bosh-stecmcell/light-bosh-stecmcell.pem
echo '-----END RSA PRIVATE KEY-----'>> light-bosh-stecmcell/light-bosh-stecmcell.pem
cp ${stemcell} light-bosh-stecmcell/publish/${VERSION}/
cd light-bosh-stecmcell
apt-get update
apt-get install ssh -y
chmod 400 light-bosh-stecmcell.pem
scp -o "StrictHostKeyChecking no" -i light-bosh-stecmcell.pem -r publish/${VERSION} light-bosh-stemcell@master.file.w3.bluemix.net:~/repo
if [[ $? != 0 ]]; then
  echo -e "Uploading the light stemcell failed"
  exit 1
fi

echo "Done"
