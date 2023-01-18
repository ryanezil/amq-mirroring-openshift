# AMQ custom init container

This custom image is used to configure AMQ mirroring in OpenShift.

The customization performs the following steps:

1. It looks for the configuration file mounted on ```/amq/extra/secrets/mirror-configuration/mirror-config.xml```. This file contains just the XML block to configure the mirroring.

    Example:

    ```xml
    <broker-connections>
     <!-- DC1 mirrors to DC2: every broker in DC1 cluster will mirror to the equivalent ordinal broker in DC2 cluster -->
     <amqp-connection
       name="mirror"
       uri="tcp://amq-dc2-tls-amqp-${ORDINAL_BROKER}-svc.dc2.svc.cluster.local:5673?clientFailureCheckPeriod=2000;connectionTTL=5000;sslEnabled=true;verifyHost=false;trustStorePath=/amq/extra/secrets/remote-cluster-truststore/client.ts;trustStorePassword=password"
       retry-interval="10000"
       reconnect-attempts="-1"
       auto-start="true"
       user="amq-demo-user"
       password="password" >
      <mirror queue-removal="true" message-acknowledgements="true" queue-creation="true" durable="false" />
     </amqp-connection>
    </broker-connections>
    ```
2. It replaces the string ```${ORDINAL_BROKER}``` with the ordinal POD number running the broker. Broker-0 in DC1 will mirror to Broker-0 in DC2, broker-1 in DC1 will mirror to Broker-1 in DC2, and so on ...
3. Insert the replacement result in the AMQ configuration file ```broker.xml```

The image is available here: ```quay.io/ryanezil/amq-mirroring/amq-broker-init-rhel8-customized:0.0.0-ocp-7.10-38```

## How To build

This image has been built following the next steps:

```command
# Set registry
$ REGISTRY_URL=quay.io/ryanezil

# Build image: execute the this command in the same directory where Dockerfile is located.
$ podman build -f Dockerfile -t ${REGISTRY_URL}/amq-mirroring/amq-broker-init-rhel8-customized:0.0.0-ocp-7.10-38 .

# Login on Quay.io and upload the image. Use your login credentials.
$ podman login -u="myuser" -p="mypassword" quay.io

# Push the image
$ podman push ${REGISTRY_URL}/amq-mirroring/amq-broker-init-rhel8-customized:0.0.0-ocp-7.10-38
```

## Use the custom init container

Include the image in the `ActiveMQArtemis` custom resource:

```yaml
  :
  :
    image: placeholder
    initImage: >-
      quay.io/ryanezil/amq-mirroring/amq-broker-init-rhel8-customized:0.0.0-ocp-7.10-38
```

