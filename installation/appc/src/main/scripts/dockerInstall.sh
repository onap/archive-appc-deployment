#!/bin/bash

###
# ============LICENSE_START=======================================================
# APPC
# ================================================================================
# Copyright (C) 2019 AT&T Intellectual Property. All rights reserved.
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
# This script runs during docker image build.
# It starts opendaylight, installs the appc features, then shuts down opendaylight.
#
ODL_HOME=${ODL_HOME:-/opt/opendaylight/current}
ODL_ADMIN_PASSWORD=${ODL_ADMIN_PASSWORD:-Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U}
SDNC_HOME=${SDNC_HOME:-/opt/onap/ccsdk}
APPC_HOME=${APPC_HOME:-/opt/onap/appc}
SLEEP_TIME=${SLEEP_TIME:-120}
MYSQL_PASSWD=${MYSQL_PASSWD:-openECOMP1.0}

appcInstallStartTime=$(date +%s)



echo "Starting OpenDaylight"
${ODL_HOME}/bin/start
echo "Waiting ${SLEEP_TIME} seconds for OpenDaylight to initialize"
sleep ${SLEEP_TIME}

echo "Copying a working version of the logging configuration into the opendaylight etc folder"
cp ${APPC_HOME}/data/org.ops4j.pax.logging.cfg ${ODL_HOME}/etc/org.ops4j.pax.logging.cfg
echo "Copying a new version of aaf cadi shiro into the opendaylight deploy folder"
cp ${APPC_HOME}/data/aaf-shiro-aafrealm-osgi-bundle.jar ${ODL_HOME}/deploy/aaf-shiro-aafrealm-osgi-bundle.jar

echo "Installing APPC platform features"
${APPC_HOME}/bin/installFeatures.sh

echo "Adding a property system.properties for AAF cadi.properties location"
echo "" >> ${ODL_HOME}/etc/system.properties
echo "cadi_prop_files=${APPC_HOME}/data/properties/cadi.properties" >> ${ODL_HOME}/etc/system.properties
echo "" >> ${ODL_HOME}/etc/system.properties

echo "Adding a value to property appc.asdc.env in appc.properties for appc-asdc-listener feature"
echo "" >> $APPC_HOME/data/properties/appc.properties
echo "appc.asdc.env=$DMAAP_TOPIC_ENV" >> $APPC_HOME/data/properties/appc.properties
echo "" >> $APPC_HOME/data/properties/appc.properties

echo "Copying the aaa shiro configuration into opendaylight"
cp ${APPC_HOME}/data/aaa-app-config.xml ${ODL_HOME}/etc/opendaylight/datastore/initial/config/aaa-app-config.xml

echo "Stopping OpenDaylight"
${ODL_HOME}/bin/stop
checkRun () {
  running=0
  while read a b c d e f g h
  do
    if [ "$h" == "/bin/sh /opt/opendaylight/bin/karaf server" ]
    then
      running=1
    fi
  done < <(ps -eaf)
  echo $running
}

while [ $( checkRun ) == 1 ]
do
  echo "Karaf is still running, waiting..."
  sleep 5s
done
echo "Karaf process has stopped"
sleep 10s

appcInstallEndTime=$(date +%s)
echo "Total Appc install took $(expr $appcInstallEndTime - $appcInstallStartTime) seconds"
