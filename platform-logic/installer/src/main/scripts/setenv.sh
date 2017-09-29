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

# Tweaking SDNC_CONFIG_DIR temporarily from ../sdnc/.. to ../appc/.. since it may be needed in this script
#    to map to SDN-C AAI Service Bundle's AAI Activator class inside the gerrit sdnc/adaptors repo, so that
#    the AAI Service bundle loads APP-C's aaiclient.properties instead of SDN-C's aaiclient.properties.
SDNC_CONFIG_DIR=${SDNC_CONFIG_DIR:-/opt/appc/data/properties}
APPC_CONFIG_DIR=${APPC_CONFIG_DIR:-/opt/appc/data/properties}

AAIURI=$(grep org.onap.ccsdk.sli.aai.uri ${SDNC_CONFIG_DIR}/aaiclient.properties | grep -v '#' | cut -d'=' -f2)

MYSQL_USER=$(grep org.onap.ccsdk.sli.jdbc.user ${SDNC_CONFIG_DIR}/dblib.properties | grep -v '#' | cut -d'=' -f2)
MYSQL_PWD=$(grep org.onap.ccsdk.sli.jdbc.password ${SDNC_CONFIG_DIR}/dblib.properties | grep -v '#' | cut -d'=' -f2)
MYSQL_DB=$(grep org.onap.ccsdk.sli.jdbc.database ${SDNC_CONFIG_DIR}/dblib.properties | grep -v '#' | cut -d'=' -f2)
MYSQL_SERVER=$(grep org.onap.ccsdk.sli.jdbc.hosts ${SDNC_CONFIG_DIR}/dblib.properties | grep -v '#' | cut -d'=' -f2 | cut -d',' -f1)

ODLUSER=$(grep controllerUser ${SDNC_CONFIG_DIR}/backup.properties | grep -v '#' | cut -d'=' -f2)
ODLPWD=$(grep controllerPass ${SDNC_CONFIG_DIR}/backup.properties | grep -v '#' | cut -d'=' -f2)

ODLHOST=$(grep odlNodes ${SDNC_CONFIG_DIR}/backup.properties | grep -v '#' | cut -d'=' -f2|cut -d',' -f1)
ODLPORT=$(grep controllerPort ${SDNC_CONFIG_DIR}/backup.properties | grep -v '#' | cut -d'=' -f2)
if [ $ODLPORT = 8443 ]
then
  ODLPROTO=https
else
  ODLPROTO=http
fi

unset HTTP_PROXY HTTPS_PROXY http_proxy https_proxy
