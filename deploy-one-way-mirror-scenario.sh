#!/bin/bash
cd "$(dirname "$0")"

echo "#### Deploying DC2 - AMQ cluster (it does not mirror to AMQ cluster on DC1) ####"
oc new-project dc2
./amq-dc2-no-mirror/create-secrets.sh
./amq-dc2-no-mirror/deploy-cluster.sh

echo "Waiting 15 seconds ..."
sleep 15

echo "#### Deploying DC1 - AMQ cluster mirroring to DC2 AMQ cluster ####"
oc new-project dc1
./amq-dc1/create-secrets.sh
./amq-dc1/deploy-cluster.sh
