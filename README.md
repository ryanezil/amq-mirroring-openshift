# Red Hat AMQ 7: mirroring on OpenShift

This repository contains configuration files and scripts to deploy two AMQ 7.10 clusters as they were deployed in two different datacenters (DC0 and DC1). Therefore, two OpenShift namespaces will play the _datacenter_ role with names ```dc0``` and ```dc1```.

1. There are two AMQ clusters: DC0 and DC1.
2. There are two brokers in every AMQ cluster deployed (size = 2).

When a `dual-mirror` configuration is deployed:

* DC0-B0 mirrors to DC1-B0 (`broker-0` in AMQ cluster `DC0` mirrors to `broker-0` in AMQ cluster `DC1`)
* DC0-B1 mirrors to DC1-B1
* DC1-B0 mirrors to DC0-B0 (`broker-0` in AMQ cluster `DC1` mirrors to `broker-0` in AMQ cluster `DC0`)
* DC1-B1 mirrors to DC0-B1

There are two scenarios available to be tested, with two different configuration approaches:

* One-way / single mirroring
* Dual mirroring

Project structure, deployment files or manifests (secrets, custom resources, etc.) are managed using [Kustomize](https://kustomize.io). You can see the generated OpenShift manifests using the command:

```command
oc kustomize ./overlays/<directory-name>/
```

For example, to see the generated manifests to deploy the AMQ cluster intended for the datacenter `DC0` with the mirror configuration defined using `BrokerProperties`, exec:

```command
oc kustomize ./overlays/dc0/
```

## 1. Scenario: **One-way mirroring**

* AMQ cluster in DC0 mirrors to AMQ cluster in DC1.
* AMQ cluster in DC1 does not mirror anything to AMQ cluster in DC0.

### 1.1 AMQ in DC0 - *initcontainer*:

* AMQ cluster in DC0 mirrors to AMQ cluster in DC1: DC0 mirroring is configured using the customized init-container image

Exec ```deploy-one-way-mirror-scenario-initcontainer.sh``` to deploy everything.

### 1.2 AMQ in DC0 - *brokerproperties*:

* AMQ cluster in DC0 mirrors to AMQ cluster in DC1: DC0 mirroring is configured using the `brokerproperties` section in the CustomResource.

Exec ```deploy-one-way-mirror-scenario-brokerproperties.sh``` to deploy everything.

## 2. Scenario: **Dual mirroring**

* AMQ cluster in DC0 mirrors to AMQ cluster in DC1.
* AMQ cluster inh DC1 mirrors to AMQ cluster in DC0.

### 2.1 AMQ configuration: *initcontainer*:

* Both AMQ clusters mirror to each other. Mirroring is configured using the customized init-container image.

Exec ```deploy-dual-mirror-scenario-initcontainer.sh``` to deploy everything.

### 2.2 AMQ configuration: *brokerproperties*:

* Both AMQ clusters mirror to each other. Mirroring is configured using the `brokerproperties` section in the CR.

Exec ```deploy-dual-mirror-scenario-brokerproperties.sh``` to deploy everything.

## Init-container image

The custom init-container image is provided to configure the mirroring and allowing the broker-pairing in every AMQ cluster:

> Broker-0 in DC1 will mirror to Broker-0 in DC2, broker-1 in DC1 will mirror to Broker-1 in DC2, and so on ... Therefore, the cluster size *must be the same* in both AMQ clusters.

## Pre-requisites

Deploy Red Hat AMQ operator before running the scripts. Cluster-wide mode is recommended.

## Documentation

* [Artemis - Broker Connections](https://activemq.apache.org/components/artemis/documentation/latest/amqp-broker-connections.html)
* [Specifying a custom Init Container image](https://access.redhat.com/documentation/en-us/red_hat_amq_broker/7.10/html-single/deploying_amq_broker_on_openshift/index#proc-br-specifying-custom-init-container_broker-ocp)
* [How to build your custom AMQ Broker image using init container image?](https://access.redhat.com/solutions/5897061)
* [Artemiscloud examples](https://github.com/artemiscloud/artemiscloud-examples/tree/main/operator/init)

