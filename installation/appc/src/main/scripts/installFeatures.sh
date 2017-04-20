#!/bin/bash

ODL_HOME=${ODL_HOME:-/opt/opendaylight/current}
APPC_HOME=${APPC_HOME:-/opt/openecomp/appc}
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
featureInstall odl-netconf-connector-all
featureInstall odl-restconf-noauth
featureInstall odl-netconf-topology

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
