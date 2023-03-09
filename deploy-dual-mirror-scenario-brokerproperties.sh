#!/bin/bash
cd "$(dirname "$0")"

echo "#### Deploying DC0 - AMQ cluster mirroring to DC1 AMQ cluster ####"
oc kustomize ./overlays/dc0/ | oc apply -f -

echo "Waiting 15 seconds ..."
sleep 15

echo "#### Deploying DC1 - AMQ cluster mirroring to DC0 AMQ cluster ####"
oc kustomize ./overlays/dc1/ | oc apply -f -
