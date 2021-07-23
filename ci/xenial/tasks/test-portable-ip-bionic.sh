#!/usr/bin/env bash
set -ex

dname=portable-ip-bionic
stemcell_path=$(realpath stemcell/*.tgz)
stemcell_version=$(realpath stemcell/version | xargs -n 1 cat)

echo "Login to bosh director"
bosh2 envs
echo "${CA_CERT}" >>~/.bosh/config
bosh2 -e ${ALIAS} upload-stemcell ${stemcell_path} --fix

# deploy new or os reload
if [[ -e "deploy-yml/yml/$dname.yml" ]]; then
  bosh2 int deploy-yml/yml/${dname}.yml \
  -v stemcell_version="\"${stemcell_version}\"" \
  -v portable_ip=${PORTABLE_IP} \
  --var-errs \
  > deploy-yml/yml/gen-${dname}.yml
  bosh2 -e ${ALIAS} -d ${dname} deploy deploy-yml/yml/gen-${dname}.yml -n
else
 echo "Deploy vm failed since the deployment yml file does not exist "
 exit 1
fi

sleep 30

vm_status=$(bosh2 -e ${ALIAS} -d ${dname} vms | grep "dummy" | awk -F ' ' '{print $2}')
if [[ "${vm_status}" = "running" ]]; then
    echo "deploy vm success"
else
    echo "failed to deploy vm"
    exit 1
fi

# Check network configuration
echo "#ifconfig of the new deployed vm:"
bosh2 -e ${ALIAS} -d ${dname} ssh -c "sudo ifconfig" | awk -F '|' '{print $2}'

portable_ip_vm=$(bosh2 -e ${ALIAS} -d ${dname} ssh -c "sudo ifconfig" | awk -F '|' '{print $2}' | grep 'eth0:[0-9]:' -A 1 | grep 'inet' | awk '{print $2}')
echo "The new vm portable ip is -" ${portable_ip_vm}

if [[ ${portable_ip_vm} == ${PORTABLE_IP} ]]; then
    echo "Portable IP check PASSED!"
else
    echo "Portable IP check FAILED!"
    exit 1
fi

# Test ping portable ip
ping -c 3 -w 5 ${PORTABLE_IP}
if [[ $? == 0 ]]; then
    echo "Successfully ping portable ip ${PORTABLE_IP}. Test passed!"
else
    echo "Failed to ping portable ip ${PORTABLE_IP}!"
fi
