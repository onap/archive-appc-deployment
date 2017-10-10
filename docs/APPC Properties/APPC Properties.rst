=========================
APPC Available Properties
=========================

Overview
========

The current list of properties that can be overwritten from all
default.properties files to `appc.properties
<https://gerrit.onap.org/r/gitweb?p=appc/deployment.git;a=blob;f=installation/src/main/properties/appc.properties;h=b2d4e1c0dfe44a6c5d7cab4b9d2a0463b2889bfd;hb=HEAD>`_ are listed below. Please note
that some properties have default values since some code requires it to
be defined as part of the building/compilation process.

-  The only defined property values in appc.properties are the
   following:

   -  "appc.demo.\*" properties (needed for demo)
   -  "appc.provider.vfodl.url" property (needed for demo)
   -  "appc.service.logic.module.name" property (needed for demo)
   -  "appc.topology.dg.\*" properties (needed for demo)

Properties List
===============

The following features have properties that can be defined by the user as explained below:

**DMaaP Event Bus**

APPC sends asynchronous responses using the DMaaP. It also receives requests from DMaaP (see the `APPC API Guide <http://onap.readthedocs.io/en/latest/submodules/appc.git/docs/APPC%20API%20Guide/APPC%20API%20Guide.html>`_ for further details).

The DMaaP Adapter Bundle handles all DMaaP operations (send / receive messages), and requires the following properties configured in */opt/openecomp/appc/data/properties/appc.properties*.

-  **dmaap.poolMembers property**:

  -  Applies to the following features: appc-command-executor-core, appc-license-manager-core, appc-lifecycle-management-core, appc-request-handler-core, and appc-workflow-management-core (all part of the appc-dispatcher package)
  -  Defines the DMaaP IP or URL location of the DMaaP Pool Members involved in the DMaaP Communication of that feature in specific (NOTE: More than one Pool Member can be defined in the form of a comma-delimited list)

-  **appc.ClosedLoop.\* properties** & **appc.ClosedLoop1607.\* properties**:

  -  Applies to the following feature: appc-event-listener-bundle
  -  These properties define in which DMaaP will the appc-event-listener feature will listen in

-  **appc.LCM.\* properties**:

  -  Applies to the following features: appc-event-listener-bundle, appc-command-executor-core, appc-license-manager-core, appc-request-handler-core, appc-workflow-management-core, and appc-lifecycle-management-core
  -  These properties define in which DMaaP will the appc-event-listener feature will listen in. These properties are especifically used to define LCM (LifeCycle Management) actions, and are only used as part of JUnit Test Cases.

-  **Other properties**:

  -  \*poolMembers, event.pool.members

    -  Applies to the following features: appc-netconf-adapter-bundle, appc-dg-common, appc-dmaap-adapter-bundle
    -  These properties can be defined to use the features defined above. They are used to point to current DMaaP listener

-  **Example**:

  .. code:: bash

	### Asynchronous responses ###
	dmaap.topic.write=<WRITE_TOPIC> // e.g. async_demo
	dmaap.poolMembers= <HOST_IP_1>:<PORT_NUMBER>,<HOST_IP_2>:<PORT_NUMBER> # e.g. 192.168.1.10:3904

	### DG events (asynchronous) in case of failures ###
	DCAE.event.topic.write=<WRITE_TOPIC> // e.g. event_demo
	DCAE.event.pool.members=<HOST_IP_1>:<PORT_NUMBER>,<HOST_IP_2>:<PORT_NUMBER> # e.g. 192.168.1.10:3904

	### LCM API (rpc) – synchronous ###
	# The following properties are required for sending an LCM request over DMaaP
	appc.LCM.provider.url=https://localhost:8443/restconf/operations/appc-provider-lcm
	appc.LCM.poolMembers=<HOST_IP_1>:<PORT_NUMBER>,<HOST_IP_2>:<PORT_NUMBER> # e.g. 192.168.1.10:3904
	appc.LCM.topic.read=<READ_TOPIC> # e.g. test123
	appc.LCM.topic.write=<WRITE_TOPIC> # e.g. APPC-LCM-TEST
	appc.LCM.client.name=<CLIENT_NAME> # e.g name1
	appc.LCM.client.name.id=<CLIENT_ID> # e.g 0
	appc.LCM.provider.user=<LCM PROVIDER Username> # e.g. admin
	appc.LCM.provider.pass=<LCM PROVIDER Username> # e.g. admin


**AAI Adaptor (SDNC-based)**

APPC connects with ONAP AAI using the SDNC AAI service (sdnc-aai-service-<VERSION_NUMBER>.zip).

To initialize AAI services on an APPC instance, the following AAI properties need to be configured in */opt/openecomp/appc/data/properties/aaiclient.properties*. The current default properties for AAI are located in `aaiclient.properties <https://gerrit.onap.org/r/gitweb?p=appc/deployment.git;a=blob;f=installation/src/main/properties/aaiclient.properties;h=c3cd088c2c97253ff56d341d749d5da9df385929;hb=HEAD>`_.

- **Example**:

  .. code:: bash

	org.onap.ccsdk.sli.adaptors.aai.ssl.trust=<SSL_Keystore_location> # Default value is /opt/openecomp/appc/data/stores/truststore.openecomp.client.jks - this default keystore currently exists in that path
	org.onap.ccsdk.sli.adaptors.aai.ssl.trust.psswd=<SSL_Keystore_Password> # Default value for the default keystore is adminadmin
	org.onap.ccsdk.sli.adaptors.aai.uri=<AAI_INSTANCE_LOCATION> # Default value is https://aai.api.simpledemo.openecomp.org:8443


**Database Connection**

APPC uses the SDNC dblib service (*sdnc-dblib-<VERSION_NUMBER>.zip*) for all database operations. The SQL driver used to connect to the MySQL Database is the MariaDB Driver/Connector.

This library uses the file, */opt/openecomp/appc/data/properties/dblib.properties*, which contains the requisite database properties, such as host, user and password. The current default properties for dblib are located in `dblib.properties <https://gerrit.onap.org/r/gitweb?p=appc/deployment.git;a=blob;f=installation/src/main/properties/dblib.properties;h=baf2f53d2900f5e1cb503951efe1857f7921b810;hb=HEAD>`_.

NOTE: The values in the default dblib.properties (link referenced above) are the default ones. These values do not need to be changed and can be left as is in order to connect to the default MySQL Database Docker Container when deploying APPC using docker-compose.

.. code:: bash

	org.onap.ccsdk.sli.jdbc.hosts=<HOST>
	org.onap.ccsdk.sli.jdbc.url=jdbc:mysql://<HOST_IP>:3306/<DB_NAME>
	org.onap.ccsdk.sli.jdbc.database=<DB_NAME>
	org.onap.ccsdk.sli.jdbc.user=<DB_USER>
	org.onap.ccsdk.sli.jdbc.password=<DB_PASSWORD>
	org.onap.ccsdk.sli.jdbc.connection.name=<DB_CONNECTION_NAME>
	org.onap.ccsdk.sli.jdbc.limit.init=<CONNECTION_POOL_INIT_SIZE> # default is 10
	org.onap.ccsdk.sli.jdbc.limit.min=<CONNECTION_POOL_MAX_SIZE> # default is 10
	org.onap.ccsdk.sli.jdbc.limit.max=<CONNECTION_POOL_MAX_SIZE> # default is 20


**APPC Transactions Database Connection**

Applies to the following features: appc-dg-common, appc-command-executor-core, appc-request-handler-core, appc-workflow-management-core.

.. code:: bash
	
	# appcctl is the default name of the APPC Database Table, equivalent to sdnctl
	org.openecomp.appc.db.url.appcctl=jdbc:mysql://<HOST_IP>:3306/appcctl
	org.openecomp.appc.db.user.appcctl=appcctl
	org.openecomp.appc.db.pass.appcctl=appcctl


**Service Logic Interpreter (SLI) - SVCLOGIC**

APPC uses the SDNC SLI service (*sdnc-sli-<VERSION_NUMBER>.zip*) to execute the DG.

To initialize SLI services, the following properties need to be configured in */opt/openecomp/appc/data/properties/svclogic.properties*. The database operations performed from the DG also use this database configuration. The current default properties for SLI are located in `svclogic.properties <https://gerrit.onap.org/r/gitweb?p=appc/deployment.git;a=blob;f=installation/src/main/properties/svclogic.properties;h=7900843184eb41f518156e6f285d21adce5fae2e;hb=HEAD>`_.

.. code:: bash
	
	org.onap.ccsdk.sli.dbtype = jdbc

	# Note : the next 4 fields are only used if org.onap.ccsdk.sli.dbtype = jdbc
	org.onap.ccsdk.sli.jdbc.url=jdbc:mysql://<HOST_IP>:3306/<DB_NAME> # jdbc:mysql://localhost:3306/sdnctl
	org.onap.ccsdk.sli.jdbc.database=<DB_NAME> # e.g. sdnctl
	org.onap.ccsdk.sli.jdbc.user=<USER> # e.g. sdnctl
	org.onap.ccsdk.sli.jdbc.password=<PASSWORD>


**IaaS (Infracstructure as a Service) Adapter**

The APPC IaaS Adapter is the southbound adapter of APPC which is responsible of executing VIM-based actions (i.e. OpenStack actions).

To initialize the IaaS Adapter service, the following properties need to be configured in */opt/openecomp/appc/data/properties/appc.properties*. The current default properties for the IaaS adaptor are located in `here <https://gerrit.onap.org/r/gitweb?p=appc/deployment.git;a=blob;f=installation/src/main/properties/appc.properties;h=7900843184eb41f518156e6f285d21adce5fae2e;hb=HEAD>`_.

Note: The IaaS Adapter currently supports the OpenStack VIM *only*, and uses the CDP Libraries to implement the code necessary to run VIM-based LCM actions.

-  **provider1.\* properties**:

  -  Applies to the following features: appc-rest-adapter-bundle, appc-chef-adapter-bundle, appc-iaas-adapter-bundle, appc-ansible-adapter-bundle, appc-rest-healthcheck-adapter-bundle
  -  These properties need to be defined in order to use OpenStack-based API executions. For example, the APPC function "restart" is in charge of restarting a VM when requested. Therefore, properties such as OpenStack credentials, tenant name, VM ID, and others pre-defined in the appc.properties need to be defined with the information of the OpenStack Environment you are deploying APPC from.

-  **test.\* properties**:

  -  Applies to the following features: appc-rest-adapter-bundle, appc-chef-adapter-bundle, appc-iaas-adapter-bundle
  -  These are properties that test OpenStack-based APPC API requests

-  **Example**:

  .. code:: bash

	# Provider (VIM) configuration
	provider1.type=<VIM_TYPE> # default value is OpenStackProvider for OpenStack conn.
	provider1.name=<VIM_PROVIDER_NAME> # default value is OpenStack for OpenStack conn.
	provider1.identity=<VIM_IDENTITY_URL> # The VIM authentication URL
	provider1.tenant1.name=<TENANT_NAME> # The Tenant Name of the VIM
	provider1.tenant1.userid=<USER_NAME> # The VIM username
	provider1.tenant1.password=<PASSWORD> # The VIM password


**Other Properties**

-  **appc.sdc.\* properties**:

  -  Used to connect to a SDC instance. Applies to the following feature: appc-sdc-listener-bundle
  -  These properties are used to test integration between the SDC ONAP component & APPC. Properties such as pointing to the DMaaP listener & topic, SDC credentials to authenticate into the SDC component, define the RESTCONF URL, and others are mapped here.

-  **restconf.user, restconf.pass properties**:

  -  Applies to the following features: appc-netconf-adapter-bundle, appc-dg-common
  -  These properties can be defined to define the RESTCONF credentials needed to execute APPC API requests from the features impacted above.


**Notes**

-  When changing a property, please make sure to restart the APPC Docker Container so that the changes kick in using "docker stop <APPC_CONTAINER_NAME>" and then "docker start <APPC_CONTAINER_NAME>".

-  When deploying APPC using the `docker-compose.yml <https://gerrit.onap.org/r/gitweb?p=appc/deployment.git;a=blob;f=docker-compose/docker-compose.yml;h=f95a5fed5820a263a546eded6b1e9bdb8eff9a0b;hb=HEAD>`_ script, please make sure that the *SDNC_CONFIG_DIR* environment variable in the appc container configuration parameters points to */opt/openecomp/appc/data/properties* (default parameter value).
