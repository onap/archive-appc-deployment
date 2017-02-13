#!/bin/bash

# Install SDN-C & APP-C platform components if not already installed and start container

ODL_HOME=${ODL_HOME:-/opt/opendaylight/current}
ODL_ADMIN_PASSWORD=${ODL_ADMIN_PASSWORD:-Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U}
SDNC_HOME=${SDNC_HOME:-/opt/openecomp/sdnc}
APPC_HOME=${APPC_HOME:-/opt/openecomp/appc}
SLEEP_TIME=${SLEEP_TIME:-120}
MYSQL_PASSWD=${MYSQL_PASSWD:-openECOMP1.0}

#
# Adding the DMAAP_TOPIC_ENV variable into APPC-ASDC-LISTENER properties
#
DMAAP_TOPIC_ENV=${DMAAP_TOPIC_ENV}

if [ -z "$DMAAP_TOPIC_ENV" ]
	then
        echo "DMAAP_TOPIC_ENV shell variable is empty. Adding default value OS-ETE-DFW"
		DMAAP_TOPIC_ENV="OS-ETE-DFW"
	else
		echo "DMAAP_TOPIC_ENV shell variable exists and it's $DMAAP_TOPIC_ENV"
fi


echo "Adding a value to property appc.asdc.env in appc.properties for appc-asdc-listener feature"
echo "" >> $APPC_HOME/data/properties/appc.properties
echo "appc.asdc.env=$DMAAP_TOPIC_ENV" >> $APPC_HOME/data/properties/appc.properties
echo "" >> $APPC_HOME/data/properties/appc.properties



#
# Wait for database to init properly
#
echo "Waiting for mysql"
until mysql -h dbhost -u root -p${MYSQL_PASSWD} mysql &> /dev/null
do
  printf "."
  sleep 1
done
echo -e "\nmysql ready"

if [ ! -f ${SDNC_HOME}/.installed ]
then
	echo "Installing SDN-C database"
	${SDNC_HOME}/bin/installSdncDb.sh
	echo "Starting OpenDaylight"
	${ODL_HOME}/bin/start
	echo "Waiting ${SLEEP_TIME} seconds for OpenDaylight to initialize"
	sleep ${SLEEP_TIME}
	echo "Installing SDN-C platform features"
	${SDNC_HOME}/bin/installFeatures.sh
	if [ -x ${SDNC_HOME}/svclogic/bin/install.sh ]
	then
		echo "Installing directed graphs"
		${SDNC_HOME}/svclogic/bin/install.sh
	fi
	
	echo "Installing APP-C platform features"
	${APPC_HOME}/bin/installFeatures.sh
	if [ -x ${APPC_HOME}/svclogic/bin/install.sh ]
	then
		echo "Installing directed graphs for APP-C"
		${APPC_HOME}/svclogic/bin/install.sh
	fi

	echo "Restarting OpenDaylight"
	${ODL_HOME}/bin/stop
	echo "Installed at `date`" > ${SDNC_HOME}/.installed
fi

exec ${ODL_HOME}/bin/karaf