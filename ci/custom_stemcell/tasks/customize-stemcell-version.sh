#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

# outputs
output_dir="version"
mkdir -p ${output_dir}

[ -f stemcell/version ] || exit 1

custom_version=$(cat stemcell/version)

# check for minor (only supports x and x.x)
if [[ "$custom_version" == *.* ]]; then
	echo "${custom_version}.1" > "${output_dir}/number" # fill in patch
else
	echo "${custom_version}.1.1" > "${output_dir}/number" # fill in minor.patch
fi

