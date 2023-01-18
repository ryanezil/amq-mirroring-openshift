#!/bin/bash
cd "$(dirname "$0")"

# AMPQ-TLS acceptor certificate
oc create secret generic tls-console-secret \
--from-file=broker.ks=amq-dc1-keystore.ks \
--from-file=client.ts=amq-dc1-keystore.ks \
--from-literal=keyStorePassword=password \
--from-literal=trustStorePassword=password

# Web Console certificate
oc create secret generic tls-amqp-secret \
--from-file=broker.ks=amq-dc1-keystore.ks \
--from-file=client.ts=amq-dc1-keystore.ks \
--from-literal=keyStorePassword=password \
--from-literal=trustStorePassword=password


# Secret containing user's passwords
# Naming convention is `security-properties-<module name>`
oc create secret generic security-properties-broker-prop-module \
--from-literal=amq-demo-user=password \
--from-literal=user-dev=user-dev-pass \
--from-literal=consoleadmin=consoleadmin-pass \
--from-literal=consoleview=consoleview-pass

# Remote cluster trust-store
oc create secret generic remote-cluster-truststore \
--from-file=broker.ks=../amq-dc2/amq-dc2-keystore.ks \
--from-file=client.ts=../amq-dc2/amq-dc2-keystore.ks \
--from-literal=keyStorePassword=password \
--from-literal=trustStorePassword=password

# Mirror configuration: connects to the remote cluster
# The secret name is referenced in the init-container script 'post-config.sh'
# DO NOT CHANGE the name
oc create secret generic mirror-configuration \
--from-file=mirror-config.xml=dc1-mirror-config.xml
