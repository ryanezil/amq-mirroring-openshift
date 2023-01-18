#!/bin/bash

echo "####################################################"
echo "##                                                ##"
echo "##         Running post-config.sh script          ##"
echo "##                                                ##"
echo "####################################################"

# Directory mounted using the 'secret' with name 'mirror-configuration' containing the file 'mirror-config.xml'

MIRROR_CONFIG_XML_FILE=/amq/extra/secrets/mirror-configuration/mirror-config.xml

if [ -f ${MIRROR_CONFIG_XML_FILE} ]; then

    echo "#### Mirroring configuration found ####"
    echo " + Configuring Cluster mirroring..."

    BROKER_CONNECTIONS_REPLACED=$(sed "s#\${ORDINAL_BROKER}#${HOSTNAME##*-}#g" ${MIRROR_CONFIG_XML_FILE})
    # Remove newlines and trailing newline.
    BROKER_CONNECTIONS_REPLACED=${BROKER_CONNECTIONS_REPLACED//$'\n'/}
    BROKER_CONNECTIONS_REPLACED=${BROKER_CONNECTIONS_REPLACED%$'\n'}

    # Insert after <acceptors> block
    sed -i "s#<\/acceptors>#<\/acceptors>\n${BROKER_CONNECTIONS_REPLACED}#g" ${CONFIG_INSTANCE_DIR}/etc/broker.xml

    echo " + Mirroring configured."
else
    echo "#### Mirroring configuration not found ####"

fi

echo "#### post-config.sh - END ####"
