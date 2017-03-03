#!/bin/bash

ODL_HOME=${ODL_HOME:-/opt/opendaylight/current}
APPC_HOME=${APPC_HOME:-/opt/openecomp/appc}
APPC_FEATURE_DIR=${APPC_FEATURE_DIR:-${APPC_HOME}/features}

APPC_FEATURES=" \
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

# When the karaf netconf feature gets installed, need to replace default password with OpenECOMP APP-C ODL Password
sed -i 's/admin<\/password>/Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U<\/password>/' ${ODL_HOME}/etc/opendaylight/karaf/99-netconf-connector.xml

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
