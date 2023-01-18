#!/bin/bash
cd "$(dirname "$0")"

oc apply -f amq-dc2-security-settings.yaml
sleep 5
oc apply -f amq-dc2.yaml

