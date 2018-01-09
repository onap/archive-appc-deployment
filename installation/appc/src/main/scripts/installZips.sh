#!/bin/bash

###
# ============LICENSE_START=======================================================
# APPC
# ================================================================================
# Copyright (C) 2017 AT&T Intellectual Property. All rights reserved.
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
# ECOMP is a trademark and service mark of AT&T Intellectual Property.
###

if [ -z "$SETTINGS_FILE" -a -z "$GLOBAL_SETTINGS_FILE" -a -s "$HOME"/.m2/settings.xml ]
then
  DEFAULT_MAVEN_SETTINGS=${HOME}/.m2/settings.xml
  SETTINGS_FILE=${SETTINGS_FILE:-${DEFAULT_MAVEN_SETTINGS}}
  GLOBAL_SETTINGS_FILE=${GLOBAL_SETTINGS_FILE:-${DEFAULT_MAVEN_SETTINGS}}
fi

APPC_HOME=${APPC_HOME:-/opt/onap/appc}
SDNC_HOME=${SDNC_HOME:-/opt/onap/sdnc}

targetDir=${1:-${APPC_HOME}}
sdnc_targetDir=${1:-${SDNC_HOME}}

#We are going to use a series of directories in the docker-stage folder to extract features to.
#By extracting features into more than one directory, we can copy them into the docker image in
#different parts, creating more even layer sizes in the docker image.
featureDir=$2/featureDir

#This value determine how many feature directories we want. The featutures will be evenly split
#into the number of directories specified. Any remainder will be put into the last directory.
#IF THE FEATURES_DIRECTORY_COUNT IS CHANGED, THE DOCKERFILE MUST ALSO BE UPDATED SINCE IT CONTAINS
#A COPY COMMAND FOR EACH FEATURE DIRECTORY!! See the Dockerfile for more information.
FEATURE_DIRECTORY_COUNT=4

APPC_FEATURES=" \
 appc-sdc-listener \
 appc-lifecycle-management \
 appc-command-executor \
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
 appc-iaas-adapter \
 appc-ansible-adapter \
 appc-oam \
 appc-sequence-generator \
 appc-config-generator \
 appc-config-data-services \
 appc-artifact-handler \
 appc-config-adaptor \
 appc-config-audit \
 appc-config-encryption-tool \
 appc-config-flow-controller \
 appc-config-params \
 appc-aai-client"

FEATURES_PER_DIRECTORY=$(($(echo $APPC_FEATURES|wc -w)/$FEATURE_DIRECTORY_COUNT))

APPC_VERSION=${APPC_VERSION:-0.0.1}
APPC_OAM_VERSION=${APPC_OAM_VERSION:-0.1.1}

if [ ! -d ${targetDir} ]
then
  mkdir -p ${targetDir}
fi

cwd=$(pwd)

mavenOpts="-s ${SETTINGS_FILE} -gs ${GLOBAL_SETTINGS_FILE}"
cd /tmp

echo "Installing APP-C version ${APPC_VERSION}"

#The math for splitting up the features into folders
featureNumber=1
featureDirNumber=1
for feature in ${APPC_FEATURES}
do
if (( $featureDirNumber < $FEATURE_DIRECTORY_COUNT ))
then
  if (( $featureNumber > $FEATURES_PER_DIRECTORY ))
  then
    featureDirNumber=$(($featureDirNumber+1))
    featureNumber=1
  fi
fi

 rm -f /tmp/${feature}-installer*.zip
 mvn -U ${mavenOpts} org.apache.maven.plugins:maven-dependency-plugin:2.9:copy -Dartifact=org.onap.appc:${feature}-installer:${APPC_VERSION}:zip -DoutputDirectory=/tmp -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.ssl.insecure=true
 unzip -d ${featureDir}$featureDirNumber /tmp/${feature}-installer*zip
featureNumber=$(($featureNumber+1))
done

echo "Installing platform-logic for APP-C"
rm -f /tmp/platform-logic-installer*.zip
mvn -U ${mavenOpts} org.apache.maven.plugins:maven-dependency-plugin:2.9:copy -Dartifact=org.onap.appc.deployment:platform-logic-installer:${APPC_OAM_VERSION}:zip -DoutputDirectory=/tmp -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.ssl.insecure=true
unzip -d ${targetDir} /tmp/platform-logic-installer*.zip

echo "Downloading dg-loader-provider jar from nexus"
mvn -U ${mavenOpts} org.apache.maven.plugins:maven-dependency-plugin:2.9:copy -Dartifact=org.onap.appc.plugins:dg-loader-provider:${APPC_VERSION}:jar:jar-with-dependencies -DoutputDirectory=${targetDir}/data
mv ${targetDir}/data/dg-loader-provider-*-jar-with-dependencies.jar ${targetDir}/data/dg-loader-provider-jar-with-dependencies.jar

find ${targetDir} -name '*.sh' -exec chmod +x '{}' \;

cd $cwd

