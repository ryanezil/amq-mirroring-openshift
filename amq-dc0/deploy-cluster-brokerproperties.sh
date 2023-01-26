#!/bin/bash
cd "$(dirname "$0")"

oc apply -f amq-dc0-security-settings.yaml
sleep 5
oc apply -f amq-dc0-brokerproperties.yaml

