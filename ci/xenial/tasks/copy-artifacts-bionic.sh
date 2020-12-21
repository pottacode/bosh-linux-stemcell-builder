#!/bin/bash

set -e -x -u

export VERSION=$( cat version/number | sed 's/\.0$//;s/\.0$//' )

echo "\n[INFO] Copying candicate stemcell to production stemcell"
cp stemcell/*.tgz light-softlayer-stemcell-prod/

echo "stable-bionic-${VERSION}" > version-tag/tag

echo "Done"