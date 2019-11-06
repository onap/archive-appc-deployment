#!/bin/bash

###
# ============LICENSE_START=======================================================
# APPC
# ================================================================================
# Copyright (C) 2017-2019 AT&T Intellectual Property. All rights reserved.
# ================================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============LICENSE_END=========================================================
###

#
# This script takes care of installing the SDNC & APPC platform components 
#  if not already installed, and starts the APPC Docker Container
#

ODL_HOME=${ODL_HOME:-/opt/opendaylight/current}
ODL_ADMIN_PASSWORD=${ODL_ADMIN_PASSWORD:-Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U}
SDNC_HOME=${SDNC_HOME:-/opt/onap/ccsdk}
APPC_HOME=${APPC_HOME:-/opt/onap/appc}
SLEEP_TIME=${SLEEP_TIME:-120}
MYSQL_PASSWD=${MYSQL_PASSWD:-openECOMP1.0}

#
# Adding the DMAAP_TOPIC_ENV variable into APPC-ASDC-LISTENER properties
#
DMAAP_TOPIC_ENV=${DMAAP_TOPIC_ENV}

if [ -z "$DMAAP_TOPIC_ENV" ]
	then
        echo "DMAAP_TOPIC_ENV shell variable is empty. Adding default value OS-ETE-DFW"
		DMAAP_TOPIC_ENV="OS-ETE-DFW"
	else
		echo "DMAAP_TOPIC_ENV shell variable exists and it's $DMAAP_TOPIC_ENV"
fi

#
# Wait for database to init properly
#
echo "Waiting for mysql"
until mysql -h dbhost -u root -p${MYSQL_PASSWD} mysql &> /dev/null
do
  printf "."
  sleep 1
done
echo -e "\nmysql ready"

if [ ! -f ${SDNC_HOME}/.installed ]
then
	echo "Installing SDNC database"
	${SDNC_HOME}/bin/installSdncDb.sh
	echo "Installing APPC database"
	${APPC_HOME}/bin/installAppcDb.sh
	echo "Installing ODL Host Key"
	${SDNC_HOME}/bin/installOdlHostKey.sh

	if [ -x ${SDNC_HOME}/svclogic/bin/install.sh ]
	then
		echo "Installing directed graphs"
		${SDNC_HOME}/svclogic/bin/install.sh
	fi
	
	
	

	if [ -x ${APPC_HOME}/svclogic/bin/install-converted-dgs.sh ]
	then
		echo "Installing APPC JSON DGs converted to XML using dg-loader"
		${APPC_HOME}/svclogic/bin/install-converted-dgs.sh
	fi
	
echo "Installed at `date`" > ${SDNC_HOME}/.installed
fi

echo "Starting cdt-proxy-service jar, logging to ${APPC_HOME}/cdt-proxy-service/jar.log"
java -jar ${APPC_HOME}/cdt-proxy-service/cdt-proxy-service.jar > ${APPC_HOME}/cdt-proxy-service/jar.log &

echo "Starting dmaap-event-service jar, logging to ${APPC_HOME}/dmaap-event-service/jar.log"
java -jar -Dorg_onap_appc_bootstrap_path=/opt/onap/appc/data/properties -Dorg_onap_appc_bootstrap_file=appc.properties ${APPC_HOME}/dmaap-event-service/dmaap-event-service.jar > ${APPC_HOME}/dmaap-event-service/jar.log &

echo "Starting ODL/APPC"

echo "Copying the aaa shiro configuration into opendaylight"
cp ${APPC_HOME}/data/aaa-app-config.xml ${ODL_HOME}/etc/opendaylight/datastore/initial/config/aaa-app-config.xml

echo "Adding a property system.properties for AAF cadi.properties location"
echo "" >> ${ODL_HOME}/etc/system.properties
echo "cadi_prop_files=${APPC_HOME}/data/properties/cadi.properties" >> ${ODL_HOME}/etc/system.properties
echo "" >> ${ODL_HOME}/etc/system.properties

echo "Adding a value to property appc.asdc.env in appc.properties for appc-asdc-listener feature"
echo "" >> $APPC_HOME/data/properties/appc.properties
echo "appc.asdc.env=$DMAAP_TOPIC_ENV" >> $APPC_HOME/data/properties/appc.properties
echo "" >> $APPC_HOME/data/properties/appc.properties

echo "Copying jetty, keystore for https into opendalight"
cp ${APPC_HOME}/data/jetty.xml ${ODL_HOME}/etc/jetty.xml
cp ${APPC_HOME}/data/keystore ${ODL_HOME}/etc/keystore
cp ${APPC_HOME}/data/custom.properties ${ODL_HOME}/etc/custom.properties

echo "Copying a working version of the logging configuration into the opendaylight etc folder"
cp ${APPC_HOME}/data/org.ops4j.pax.logging.cfg ${ODL_HOME}/etc/org.ops4j.pax.logging.cfg

ODL_BOOT_FEATURES_EXTRA="odl-netconf-connector,odl-restconf-noauth,odl-netconf-clustered-topology,odl-mdsal-clustering"
sed -i -e "\|featuresBoot[^a-zA-Z]|s|$|,${ODL_BOOT_FEATURES_EXTRA}|"  $ODL_HOME/etc/org.apache.karaf.features.cfg

exec ${APPC_HOME}/bin/dockerInstall.sh &
echo "Starting OpenDaylight"
exec ${ODL_HOME}/bin/karaf server
