#!/bin/bash

ODL_HOME=${ODL_HOME:-/opt/opendaylight/current}
APPC_HOME=${APPC_HOME:-/opt/openecomp/appc}
APPC_FEATURE_DIR=${APPC_FEATURE_DIR:-${APPC_HOME}/features}

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
 
echo "Enabling core APP-C features"
${ODL_HOME}/bin/client -u karaf feature:install odl-netconf-connector-all
${ODL_HOME}/bin/client -u karaf feature:install odl-restconf-noauth
${ODL_HOME}/bin/client -u karaf feature:install odl-netconf-topology

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
