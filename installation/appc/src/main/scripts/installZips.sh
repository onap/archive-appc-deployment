#!/bin/bash

APPC_HOME=${APPC_HOME:-/opt/openecomp/appc}
SDNC_HOME=${SDNC_HOME:-/opt/openecomp/sdnc}

targetDir=${1:-${APPC_HOME}}
sdnc_targetDir=${1:-${SDNC_HOME}}

featureDir=${targetDir}/features

APPC_FEATURES=" \
 appc-iaas-adapter \
 appc-provider \
 appc-event-listener \
 appc-dispatcher \
 appc-chef-adapter \
 appc-netconf-adapter \
 appc-rest-adapter \
 appc-dmaap-adapter \
 appc-dg-util \
 appc-metric \
 appc-dg-shared \
 appc-asdc-listener"

APPC_VERSION=${APPC_VERSION:-0.0.1}
APPC_OAM_VERSION=${APPC_OAM_VERSION:-0.1.1}

if [ ! -d ${targetDir} ]
then
  mkdir -p ${targetDir}
fi

if [ ! -d ${featureDir} ]
then
  mkdir -p ${featureDir}
fi

cwd=$(pwd)

mavenOpts=${2:-"-s ${SETTINGS_FILE}"}
cd /tmp

echo "Installing APP-C version ${APPC_VERSION}"
for feature in ${APPC_FEATURES}
do
 rm -f /tmp/${feature}-installer*.zip
 mvn -U ${mavenOpts} org.apache.maven.plugins:maven-dependency-plugin:2.9:copy -Dartifact=org.openecomp.appc:${feature}-installer:${APPC_VERSION}:zip -DoutputDirectory=/tmp -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.ssl.insecure=true
 unzip -d ${featureDir} /tmp/${feature}-installer*zip
done

echo "Installing platform-logic for APP-C"
rm -f /tmp/platform-logic-installer*.zip
mvn -U ${mavenOpts} org.apache.maven.plugins:maven-dependency-plugin:2.9:copy -Dartifact=org.openecomp.appc.deployment:platform-logic-installer:${APPC_OAM_VERSION}:zip -DoutputDirectory=/tmp -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.ssl.insecure=true
unzip -d ${targetDir} /tmp/platform-logic-installer*.zip

find ${targetDir} -name '*.sh' -exec chmod +x '{}' \;

cd $cwd

