#!/usr/bin/env bash

set -ex

dname=custom-stemcell-bionic

bosh2 envs
echo "${CA_CERT}" >>~/.bosh/config 
stemcell_version=$(cat version/number | sed 's/\.0$//;s/\.0$//')
stemcell_filename=light-bosh-stemcell-${stemcell_version}-${IAAS}-${HYPERVISOR}-${OS_NAME}-${OS_VERSION}-go_agent.tgz
bosh2 -e ${ALIAS} deld -d ${dname} -n
# bosh2 -e ${ALIAS} delete-stemcell bosh-bluemix-xen-ubuntu-xenial-go_agent/${stemcell_version} -n
bosh2 -e ${ALIAS} upload-stemcell https://${endpoint}/${bucket}/${stemcell_filename} --fix
bosh2 -e ${ALIAS} upload-release http://${filew3_server}/releases/security-release/${RELEASE}/${RELEASE}-security-release.tgz

if [ -e "deploy-yml/yml/${dname}.yml" ]; then
  bosh2 int deploy-yml/yml/${dname}.yml \
  -v stemcell_version=${stemcell_version} \
  -v SR_version=${RELEASE} \
  -v crowdstrike_version=${crowdstrike_version} \
  --var-errs \
  > deploy-yml/yml/gen-${dname}.yml
  bosh2 -e ${ALIAS} -d ${dname} deploy deploy-yml/yml/gen-${dname}.yml --no-redact -n
else
 echo "Deploy vm failed since the deployment yml file does not exist "
 exit 1
fi

# bosh2 -e ${ALIAS} ssh -c "sudo chmod 777 /var/vcap/jobs/post-deploy/config/certs/logstash/ca.pem" -d ${dname}
# bosh2 -e ${ALIAS} ssh -c "sudo chmod 777 /var/vcap/jobs/post-deploy/config/certs/logstash/client.crt" -d ${dname}
# bosh2 -e ${ALIAS} ssh -c "sudo chmod 777 /var/vcap/jobs/post-deploy/config/certs/logstash/client.key" -d ${dname}
# bosh2 -e ${ALIAS} ssh -c "echo '${security_client_crt}' >/var/vcap/jobs/post-deploy/config/certs/logstash/client.crt" -d ${dname} >/dev/null
# bosh2 -e ${ALIAS} ssh -c "echo '${security_client_key}' >/var/vcap/jobs/post-deploy/config/certs/logstash/client.key" -d ${dname} >/dev/null
# bosh2 -e ${ALIAS} ssh -c "echo '${security_ca_pem}' >/var/vcap/jobs/post-deploy/config/certs/logstash/ca.pem" -d ${dname} >/dev/null
# sleep 60
# vm_status=`bosh2 -e ${ALIAS} vms |grep "${dname}" |awk -F ' ' '{print $2}'`
#
# if [ "${vm_status}" = "running" ]; then
#     echo "deploy vm success"
# else
#     echo "failed to deploy vm"
#     exit 1
# fi

private_ip=`bosh2 -e ${ALIAS} ssh -c "sudo ifconfig" -d ${dname} | grep -A1 eth0 | grep inet | awk '{print $2}'`
echo "The new vm private ip is " $private_ip