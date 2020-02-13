#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

# outputs
output_dir="version"
mkdir -p ${output_dir}

# eg. 170.19.2 -> 170.19.3
custom_version=$(cat version/number)
new_custom_version=$(echo ${custom_version} | awk 'BEGIN{FS=OFS="."}{$NF+=1;print}')

echo "${new_custom_version}" > "${output_dir}/number"