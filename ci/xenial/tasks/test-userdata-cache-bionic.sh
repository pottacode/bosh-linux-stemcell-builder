#!/usr/bin/env bash
set -e

dname=userdata-cache-bionic
stemcell_path=$(realpath stemcell/*.tgz)
stemcell_version=$(realpath stemcell/version | xargs -n 1 cat)

echo "Login to bosh director"
bosh2 envs
echo "${CA_CERT}" >>~/.bosh/config
bosh2 -e ${ALIAS} upload-stemcell ${stemcell_path} --fix

# deploy new
if [[ -e "deploy-yml/yml/$dname.yml" ]]; then
  bosh2 int deploy-yml/yml/${dname}.yml \
  -v stemcell_version=${stemcell_version} \
  --var-errs \
  > deploy-yml/yml/gen-${dname}.yml
  bosh2 -e ${ALIAS} -d ${dname} deploy deploy-yml/yml/gen-${dname}.yml -n
else
 echo "Deploy vm failed since the deployment yml file does not exist "
 exit 1
fi

vm_status=$(bosh2 -e ${ALIAS} -d ${dname} vms | grep "test" | awk -F ' ' '{print $2}')
if [[ "${vm_status}" = "running" ]]; then
    echo "deploy vm success"
else
    echo "failed to deploy vm"
    exit 1
fi

# Check if userdata_cache.json exists
echo "#ifconfig of the new deployed vm:"
bosh2 -e ${ALIAS} -d ${dname} ssh -c "sudo ls -l /var/vcap/bosh/userdata_cache.json" | awk -F '|' '{print $2}'

result=$(bosh2 -e ${ALIAS} -d ${dname} ssh -c "sudo ls -l /var/vcap/bosh/userdata_cache.json" | awk -F '|' '{print $2}')
if [[ ${result} =~ "No such file" ]]; then
    echo "No /var/vcap/bosh/userdata_cache.json file found. Test FAILED!"
    exit 1
else
    echo "/var/vcap/bosh/userdata_cache.json file exists. Test PASSED!"
fi

# Clean env
bosh2 -e ${ALIAS} -d ${dname} delete-deployment -n