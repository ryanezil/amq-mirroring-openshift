# Red Hat AMQ 7: mirroring PoC on OpenShift

This repository contains configuration files and scripts to deploy two AMQ 7.10 clusters as they were deployed in two different datacenters (DC1 and DC2). Therefore, two OpenShift namespaces will play the _datacenter_ role with names ```dc1``` and ```dc2```.

There are two scenarios available:

1. **One-way mirroring**:
* AMQ cluster on DC1 will mirror to AMQ cluster on DC2.
* AMQ cluster on DC2 do not mirror anything to AMQ cluster on DC1.

2. **Dual mirroring**
* AMQ cluster on DC1 will mirror to AMQ cluster on DC2.
* AMQ cluster on DC2 will mirror to AMQ cluster on DC1.

A custom init-container image is provided to configure the mirroring and allowing the broker-pairing in every AMQ cluster:

    Broker-0 in DC1 will mirror to Broker-0 in DC2, broker-1 in DC1 will mirror to Broker-1 in DC2, and so on ... Therefore, the cluster size must be the same in both AMQ clusters.

## Pre-requisites

Deploy Red Hat AMQ operator before running the scripts. Cluster-wide mode is recommended.

## Deploy the scenarios

1. One-way mirroring

    * Exec the script ```deploy-one-way-mirror-scenario.sh```

2. Dual mirroring

    * Exec the script ```deploy-dual-mirror-scenario.sh```


**NOTE**: The cluster size is set to **1** in both scenarios. Increase the value in order to test different configurations.    

## Documentation

* [Artemis - Broker Connections](https://activemq.apache.org/components/artemis/documentation/latest/amqp-broker-connections.html)
* [Specifying a custom Init Container image](https://access.redhat.com/documentation/en-us/red_hat_amq_broker/7.10/html-single/deploying_amq_broker_on_openshift/index#proc-br-specifying-custom-init-container_broker-ocp)
* [How to build your custom AMQ Broker image using init container image?](https://access.redhat.com/solutions/5897061)
* [Artemiscloud examples](https://github.com/artemiscloud/artemiscloud-examples/tree/main/operator/init)

