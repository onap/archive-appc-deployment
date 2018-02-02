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

ODL_HOME=${ODL_HOME:-/opt/opendaylight/current}
APPC_HOME=${APPC_HOME:-/opt/onap/appc}
APPC_FEATURE_DIR=${APPC_FEATURE_DIR:-${APPC_HOME}/features}

function featureInstall {
COUNT=0
while [ $COUNT -lt 10 ]; do
  ${ODL_HOME}/bin/client -u karaf feature:install $1 2> /tmp/installErr
  cat /tmp/installErr
  if grep -q 'Failed to get the session' /tmp/installErr; then
    sleep 10
  else
    let COUNT=10
  fi
  let COUNT=COUNT+1
done
}

APPC_FEATURES=" \
 appc-metric \
 appc-dmaap-adapter \
 appc-event-listener \
 appc-chef-adapter \
 appc-netconf-adapter \
 appc-rest-adapter \
 appc-lifecycle-management \
 appc-dispatcher \
 appc-provider \
 appc-dg-util \
 appc-dg-shared \
 appc-sdc-listener \
 appc-oam \
 appc-iaas-adapter \
 appc-ansible-adapter \
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

# Temp fix to fix bouncycastle issue that is preventing netconf to work correctly
apt-get -y install wget
wget -P /opt/opendaylight/current/deploy https://www.bouncycastle.org/download/bcprov-jdk15on-158.jar
wget -P /opt/opendaylight/current/deploy https://www.bouncycastle.org/download/bcprov-ext-jdk15on-158.jar

echo "Enabling core APP-C features"
featureInstall odl-netconf-connector-all
featureInstall odl-restconf-noauth
featureInstall odl-netconf-topology

echo "Installing APP-C Features"
echo ""

for feature in ${APPC_FEATURES}
do
  if [ -f ${APPC_FEATURE_DIR}/${feature}/install-feature.sh ]
  then
    ${APPC_FEATURE_DIR}/${feature}/install-feature.sh
  else
    echo "No installer found for feature ${feature}"
  fi
done
