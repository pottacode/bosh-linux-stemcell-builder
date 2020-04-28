#!/usr/bin/env bash

set -ex

bosh2 envs
echo "${CA_CERT}" >>~/.bosh/config 
stemcell_version=$(cat version/number | sed 's/\.0$//;s/\.0$//')
stemcell_filename=light-bosh-stemcell-${stemcell_version}-${IAAS}-${HYPERVISOR}-${OS_NAME}-${OS_VERSION}-go_agent.tgz
bosh2 -e ${ALIAS} deld -d custom-stemcell -n
bosh2 -e ${ALIAS} delete-stemcell bosh-bluemix-xen-ubuntu-xenial-go_agent/${stemcell_version} -n
bosh2 -e ${ALIAS} upload-stemcell https://${endpoint}/${bucket}/${stemcell_filename}
bosh2 -e ${ALIAS} upload-release http://${filew3_server}/releases/security-release/${RELEASE}/${RELEASE}-security-release.tgz

if [ -e "deploy-yml/yml/custom-stemcell.yml" ]; then
  bosh2 int deploy-yml/yml/custom-stemcell.yml \
  -v stemcell_version=${stemcell_version} \
  -v SR_version=${RELEASE} \
  -v crowdstrike_version=${crowdstrike_version} \
  --var-errs \
  > deploy-yml/yml/gen-custom-stemcell.yml
  bosh2 -e ${ALIAS} -d custom-stemcell deploy deploy-yml/yml/gen-custom-stemcell.yml --no-redact -n
else
 echo "Deploy vm failed since the deployment yml file does not exist "
 exit 1
fi

# bosh2 -e ${ALIAS} ssh -c "sudo chmod 777 /var/vcap/jobs/post-deploy/config/certs/logstash/ca.pem" -d custom-stemcell
# bosh2 -e ${ALIAS} ssh -c "sudo chmod 777 /var/vcap/jobs/post-deploy/config/certs/logstash/client.crt" -d custom-stemcell
# bosh2 -e ${ALIAS} ssh -c "sudo chmod 777 /var/vcap/jobs/post-deploy/config/certs/logstash/client.key" -d custom-stemcell
# bosh2 -e ${ALIAS} ssh -c "echo '${security_client_crt}' >/var/vcap/jobs/post-deploy/config/certs/logstash/client.crt" -d custom-stemcell >/dev/null
# bosh2 -e ${ALIAS} ssh -c "echo '${security_client_key}' >/var/vcap/jobs/post-deploy/config/certs/logstash/client.key" -d custom-stemcell >/dev/null
# bosh2 -e ${ALIAS} ssh -c "echo '${security_ca_pem}' >/var/vcap/jobs/post-deploy/config/certs/logstash/ca.pem" -d custom-stemcell >/dev/null
# sleep 60
# vm_status=`bosh2 -e ${ALIAS} vms |grep "custom-stemcell" |awk -F ' ' '{print $2}'`
#
# if [ "${vm_status}" = "running" ]; then
#     echo "deploy vm success"
# else
#     echo "failed to deploy vm"
#     exit 1
# fi

private_ip=`bosh2 -e ${ALIAS} ssh -c "sudo ifconfig" -d custom-stemcell |grep 'inet addr' |head -1 |awk -F ':' '{print $3}'|awk -F ' ' '{print $1}'`
echo "The new vm private ip is " $private_ip