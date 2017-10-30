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

###
### Convert XML DGs to JSON DGs using dg-loader, then load/activate them in the MySQL DB. ###
###

export APPC_HOME=${APPC_HOME:-/opt/openecomp/appc}

# SVCLOGIC_DIR env variable points to /opt/openecomp/appc/svclogic
export SVCLOGIC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

#Path to the dg-loader jar file
export DG_LOADER=${APPC_HOME}/data/dg-loader-provider-1.1.0-jar-with-dependencies.jar

# Check if the JSON Directory exists under the env. variable defined
export DG_JSON_DIR=${SVCLOGIC_DIR}/graphs/appc/json/dg-loader-dgs
echo "Processing DG JSON directory : ${DG_JSON_DIR}"
if [ ! -d "$DG_JSON_DIR" ] 
then
    echo "DG-Loader JSON Directory is Missing"
exit 1
fi


cd ${DG_JSON_DIR}
mkdir -p ${DG_JSON_DIR}/converted-xml

# Generate XML DGs from JSON DGs
$JAVA_HOME/bin/java -cp ${DG_LOADER} org.openecomp.sdnc.dg.loader.DGXMLGenerator ${DG_JSON_DIR} ${DG_JSON_DIR}/converted-xml

# Load converted XML DGs to the SVC_LOGIC DB in the MySQL Docker Container
$JAVA_HOME/bin/java -cp ${DG_LOADER} org.openecomp.sdnc.dg.loader.DGXMLLoad ${DG_JSON_DIR}/converted-xml ${APPC_HOME}/data/properties/dblib.properties

# Activate converted XML DGs to the SVC_LOGIC DB in the MySQL Docker Container
$JAVA_HOME/bin/java -cp ${DG_LOADER} org.openecomp.sdnc.dg.loader.DGXMLActivate ${DG_JSON_DIR}/dg_activate.txt ${APPC_HOME}/data/properties/dblib.properties

exit 0
