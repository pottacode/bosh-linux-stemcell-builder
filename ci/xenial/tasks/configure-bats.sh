#!/bin/bash

set -ex

cat > bats-config/bats.env <<EOF
export BAT_DNS_HOST=do-not-use
export BAT_INFRASTRUCTURE=softlayer
export BAT_NETWORKING=dynamic
export BAT_PRIVATE_KEY="${BAT_PRIVATE_KEY}"
export BAT_DEBUG_MODE=true

export BOSH_OS_BATS=false

export BOSH_ENVIRONMENT=${DIRECTOR_IP}
export BOSH_CLIENT=${BOSH_USER_NAME}
export BOSH_CLIENT_SECRET=${BOSH_PASSWORD}
export BOSH_CA_CERT="${BOSH_CA}"

export BAT_RSPEC_FLAGS="--tag ~vip_networking --tag ~manual_networking --tag ~root_partition --tag ~raw_ephemeral_storage --tag ~multiple_manual_networks"
EOF

cat > interpolate.yml <<EOF
---
cpi: softlayer
properties:
  use_static_ip: false
  use_vip: false
  pool_size: 1
  instances: 1
  stemcell:
    name: ((STEMCELL_NAME))
    version: latest
  cloud_properties:
    hostname_prefix: ((SL_VM_NAME_PREFIX))
    datacenter: ((SL_DATACENTER))
    domain: ((SL_VM_DOMAIN))
  networks:
  - name: default
    type: dynamic
    cloud_properties:
      vlan_ids:
      - ((SL_VLAN_PUBLIC))
      - ((SL_VLAN_PRIVATE))
  dns:
  - 8.8.8.8
  - 10.0.80.11
  - 10.0.80.12
EOF

bosh-cli interpolate \
 -v STEMCELL_NAME=${STEMCELL_NAME} \
 -v SL_VM_NAME_PREFIX=${SL_VM_NAME_PREFIX} \
 -v SL_DATACENTER=${SL_DATACENTER} \
 -v SL_VM_DOMAIN=${SL_VM_DOMAIN} \
 -v SL_VLAN_PUBLIC=${SL_VLAN_PUBLIC} \
 -v SL_VLAN_PRIVATE=${SL_VLAN_PRIVATE} \
 interpolate.yml \
 > bats-config/bats-config.yml
