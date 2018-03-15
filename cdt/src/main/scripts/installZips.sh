#!/bin/bash

###
# ============LICENSE_START=======================================================
# APPC
# ================================================================================
# Copyright (C) 2018 AT&T Intellectual Property. All rights reserved.
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

targetDir=${1}
sdnc_targetDir=${1}



APPC_VERSION=${APPC_VERSION:-0.0.1}
APPC_OAM_VERSION=${APPC_OAM_VERSION:-0.1.1}

if [ ! -d ${targetDir} ]
then
  mkdir -p ${targetDir}
fi

cwd=$(pwd)

mavenOpts="-s ${SETTINGS_FILE} -gs ${GLOBAL_SETTINGS_FILE}"
cd /tmp



echo "Downloading cdt code from nexus"
mvn -U ${mavenOpts} org.apache.maven.plugins:maven-dependency-plugin:2.9:copy -Dartifact=org.onap.appc.cdt:config-design-tool:${APPC_VERSION}:zip -DoutputDirectory=/tmp
unzip -d ${targetDir}/config-design-tool /tmp/config-design-tool*.zip


cd $cwd

