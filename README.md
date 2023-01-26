# Red Hat AMQ 7: mirroring PoC on OpenShift

This repository contains configuration files and scripts to deploy two AMQ 7.10 clusters as they were deployed in two different datacenters (DC0 and DC1). Therefore, two OpenShift namespaces will play the _datacenter_ role with names ```dc0``` and ```dc1```.

1. There are two AMQ clusters: DC0 and DC1.
2. There are two brokers in every AMQ cluster deployed (size = 2).

When a `dual-mirror` configuration is deployed:

* DC0-B0 mirrors to DC1-B0 (`broker-0` in AMQ cluster `DC0` mirrors to `broker-0` in AMQ cluster `DC1`)
* DC0-B1 mirrors to DC1-B1
* DC1-B0 mirrors to DC0-B0
* DC1-B1 mirrors to DC0-B1

There are two scenarios available to be tested, with different configuration approaches:

* One-way / single mirroring
* Dual mirroring

## 1. Scenario: **One-way mirroring**

* AMQ cluster on DC0 mirrors to AMQ cluster on DC1.
* AMQ cluster on DC1 does not mirror anything to AMQ cluster on DC0.

### 1.1 AMQ on DC0 - *initcontainer*:

* AMQ cluster on DC0 mirrors to AMQ cluster on DC1: DC0 mirroring is configured using the init-container

Exec ```deploy-one-way-mirror-scenario-initcontainer.sh```

### 1.2 AMQ on DC0 - *brokerproperties*:

* AMQ cluster on DC0 mirrors to AMQ cluster on DC1: DC0 mirroring is configured using the `brokerproperties` section in the CR.

Exec ```deploy-one-way-mirror-scenario-brokerproperties.sh```

## 2. Scenario: **Dual mirroring**

* AMQ cluster on DC0 mirrors to AMQ cluster on DC1.
* AMQ cluster on DC1 mirrors to AMQ cluster on DC0.

### 2.1 AMQ configuration: *initcontainer*:

* Both AMQ clusters mirror to each other. Mirroring is configured using the init-container.

Exec ```deploy-dual-mirror-scenario-initcontainer.sh```

### 2.2 AMQ configuration: *brokerproperties*:

* Both AMQ clusters mirror to each other. Mirroring is configured using the `brokerproperties` section in the CR.

Exec ```deploy-dual-mirror-scenario-brokerproperties.sh```

## Init-container image

The custom init-container image is provided to configure the mirroring and allowing the broker-pairing in every AMQ cluster:

> Broker-0 in DC1 will mirror to Broker-0 in DC2, broker-1 in DC1 will mirror to Broker-1 in DC2, and so on ... Therefore, the cluster size must be the same in both AMQ clusters.

## Pre-requisites

Deploy Red Hat AMQ operator before running the scripts. Cluster-wide mode is recommended.

## Documentation

* [Artemis - Broker Connections](https://activemq.apache.org/components/artemis/documentation/latest/amqp-broker-connections.html)
* [Specifying a custom Init Container image](https://access.redhat.com/documentation/en-us/red_hat_amq_broker/7.10/html-single/deploying_amq_broker_on_openshift/index#proc-br-specifying-custom-init-container_broker-ocp)
* [How to build your custom AMQ Broker image using init container image?](https://access.redhat.com/solutions/5897061)
* [Artemiscloud examples](https://github.com/artemiscloud/artemiscloud-examples/tree/main/operator/init)

## Pending stuff

Move to deployment/YAML files with `kustomize` and overlays.