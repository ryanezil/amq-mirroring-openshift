#!/bin/bash
cd "$(dirname "$0")"

# AMPQ-TLS acceptor certificate
oc create secret generic tls-console-secret \
--from-file=broker.ks=amq-dc1-keystore.ks \
--from-file=client.ts=amq-dc1-keystore.ks \
--from-literal=keyStorePassword=password \
--from-literal=trustStorePassword=password

# MQTT-TLS acceptor certificate
oc create secret generic tls-mqtt-secret \
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
