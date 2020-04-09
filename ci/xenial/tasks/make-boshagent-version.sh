#!/usr/bin/env bash

set -e -x

# outputs
output_dir="boshagent-version"

[ -f published-stemcell/version ] || exit 1

published_stemcell_version=$(cat published-stemcell/version)
latest_bump_boshagent_version=`curl https://github.com/cloudfoundry/bosh-linux-stemcell-builder/commits/ubuntu-xenial/v$published_stemcell_version | grep "bump bosh-agent" | awk -F '\"' '{print $2}' | head -1 | awk -F '\/' '{print $2}'`
echo "$latest_bump_boshagent_version" > "${output_dir}/number"
