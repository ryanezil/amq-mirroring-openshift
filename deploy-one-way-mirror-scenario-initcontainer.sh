#!/bin/bash
cd "$(dirname "$0")"

echo "#### Deploying DC1 - AMQ cluster (it does not mirror to AMQ cluster on DC0) ####"
oc new-project dc1
./amq-dc1-no-mirror/create-secrets.sh
./amq-dc1-no-mirror/deploy-cluster.sh

echo "Waiting 15 seconds ..."
sleep 15

echo "#### Deploying DC0 - AMQ cluster mirroring to DC1 AMQ cluster ####"
oc new-project dc0
./amq-dc0/create-secrets.sh
./amq-dc0/deploy-cluster-initcontainer.sh
