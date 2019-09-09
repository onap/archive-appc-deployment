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
ODL_HOME=${ODL_HOME:-/opt/opendaylight}
ODL_ADMIN_PASSWORD=${ODL_ADMIN_PASSWORD:-Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U}
SDNC_HOME=${SDNC_HOME:-/opt/onap/ccsdk}
APPC_HOME=${APPC_HOME:-/opt/onap/appc}
SLEEP_TIME=${SLEEP_TIME:-120}
MYSQL_PASSWD=${MYSQL_PASSWD:-openECOMP1.0}

appcInstallStartTime=$(date +%s)


echo "Waiting ${SLEEP_TIME} seconds for OpenDaylight to initialize"
sleep ${SLEEP_TIME}

echo "Checking that Karaf can be accessed"
clientOutput=$(${ODL_HOME}/bin/client shell:echo KarafLoginCheckIsWorking)
if echo "$clientOutput" | grep -q "KarafLoginCheckIsWorking"; then
echo "Karaf login succeeded"
else
echo "Error during Karaf login"
exit 1
fi

echo "Installing APPC platform features"
${APPC_HOME}/bin/installFeatures.sh

appcInstallEndTime=$(date +%s)
echo "Total Appc install took $(expr $appcInstallEndTime - $appcInstallStartTime) seconds"
