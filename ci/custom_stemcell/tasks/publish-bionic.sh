#!/usr/bin/env bash

set -e -x

VERSION=$(cat version/number | sed 's/\.0$//;s/\.0$//')
mkdir -p bluemix-stemcell
cp light-bluemix-stemcell/*.tgz bluemix-stemcell/
                                                                                    
fileUrl=https://s3.us.cloud-object-storage.appdomain.cloud/${PUBLISHED_BUCKET_NAME}/light-bosh-stemcell-${VERSION}-bluemix-xen-ubuntu-bionic-go_agent.tgz
echo -e "Stemcell Download URL -> ${fileUrl}"
checksum=`curl -L ${fileUrl} | sha1sum | cut -d " " -f 1`
echo -e "Sha1 hashcode -> $checksum"

echo "Done"
