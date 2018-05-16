.. ============LICENSE_START==========================================
.. ===================================================================
.. Copyright © 2017-2018 AT&T Intellectual Property. All rights reserved.
.. ===================================================================
.. Licensed under the Creative Commons License, Attribution 4.0 Intl.  (the "License");
.. you may not use this documentation except in compliance with the License.
.. You may obtain a copy of the License at
.. 
..  https://creativecommons.org/licenses/by/4.0/
.. 
.. Unless required by applicable law or agreed to in writing, software
.. distributed under the License is distributed on an "AS IS" BASIS,
.. WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
.. See the License for the specific language governing permissions and
.. limitations under the License.
.. ============LICENSE_END============================================

===============
APPC Properties
===============

Overview
========

The primary properties file for appc is: `appc.properties
<https://gerrit.onap.org/r/gitweb?p=appc/deployment.git;a=blob;f=installation/src/main/properties/appc.properties;h=b2d4e1c0dfe44a6c5d7cab4b9d2a0463b2889bfd;hb=HEAD>`_.

The properties in the appc.properties file override properties which are defined in "default.properties" files throughout the project. The properties in these default files should not be modified, instead the properties should be added to the appc.properties which will override the default values.

There are several other property files as well, which are covered on this page. All property files can be found in the `appc deployment project /installation/src/main/properties
<https://gerrit.onap.org/r/gitweb?p=appc/deployment.git;a=tree;f=installation/src/main/properties;h=9472f0eca62d393c7af7ebe69f55d02301616a3e;hb=refs/heads/master>`_.



Notes
=====

-  When changing a property, please make sure to restart the APPC Docker Container so that the changes kick in using "docker stop <APPC_CONTAINER_NAME>" and then "docker start <APPC_CONTAINER_NAME>".

-  When deploying APPC using the `docker-compose.yml <https://gerrit.onap.org/r/gitweb?p=appc/deployment.git;a=blob;f=docker-compose/docker-compose.yml;h=f95a5fed5820a263a546eded6b1e9bdb8eff9a0b;hb=HEAD>`_ script, please make sure that the *SDNC_CONFIG_DIR* environment variable in the appc container configuration parameters points to */opt/onap/appc/data/properties* (default parameter value).


appc.properties
===============

**Event Listener Properties**

Each event listener which is defined ("LCM" and "demo" by default) has the following properties. Each property name is prefixed by the event listener which the property is for (for example
appc.demo.property_name or appc.LCM.property_name). In the below list, each property will be prefixed with "appc.eventListener".

-  **appc.eventListener.poolMembers**:
   Comma separated list which defines the DMaaP servers which will be used by the event listener.
-  **appc.eventListener.topic.read**:
   The DMaaP topic name that will be used for incoming messages.
-  **appc.eventListener.topic.write**:
   The DMaaP topic name which will be used for outgoing messages.
-  **appc.eventListener.client.name**:
   The DMaaP client name. The client name should be unique within the topic name that you are using.
-  **appc.eventListener.threads.queuesize.min**:
   The minimum size of the event listener message processing queue. The listener will request new messages once the queue has dropped below this size.
-  **appc.eventListener.threads.queuesize.max**:
   The maximum size of the event listener message processing queue. The listener will request no new messages once this maximum size has been reached.
-  **appc.eventListener.threads.poolsize.min**:
   The minimum size of the worker threads pool. This is the pool each listener will use to launch longer running operations.
-  **appc.eventListener.threads.poolsize.max**:
   The maximum size of the worker threads pool. This is the pool each listener will use to launch longer running operations.
-  **appc.eventListener.provider.url**:
   The url of the local OpenDaylight instance that the event listener will use to process the DMaaP message once it has been parsed into the correct format.
-  **appc.eventListener.provider.user / appc.eventListener.provider.pass**:
   The username and password for the local OpenDaylight instance, defined by the url property above.


**Properties specific to the demo event listener and use case**

-  **appc.provider.vfodl.url**:
   The URl to the pg-streams method of the mounted vfirewall/traffic generator. The url string should have the placeholder "NODE_NAME", which will be filled in by the "generic-vnf.vnf-id" of the incoming DMaaP message.
-  **appc.service.logic.module.name**:
   The module name in the svclogic database table of the directed graph which will be used by the demo provider to process the request.
-  **appc.topology.dg.method**:
   The method name in the svclogic database table of the directed graph which will be used by the demo provider to process the request.
-  **appc.topology.dg.version**:
   The version number in the svclogic database table of the directed graph which will be used by the demo provider to process the request.

**IaaS (Infracstructure as a Service) Adapter**

The APPC IaaS Adapter is the southbound adapter of APPC which is responsible of executing VIM-based actions (i.e. OpenStack actions).

To initialize the IaaS Adapter service, the following properties need to be configured in */opt/onap/appc/data/properties/appc.properties*. The current default properties for the IaaS adaptor are located in `here <https://gerrit.onap.org/r/gitweb?p=appc/deployment.git;a=blob;f=installation/src/main/properties/appc.properties;h=7900843184eb41f518156e6f285d21adce5fae2e;hb=HEAD>`_.

Note: The IaaS Adapter currently supports the OpenStack VIM *only*, and uses the CDP Libraries to implement the code necessary to run VIM-based LCM actions.

-  **provider1.\* properties**:

  -  Applies to the following features: appc-rest-adapter-bundle, appc-chef-adapter-bundle, appc-iaas-adapter-bundle, appc-ansible-adapter-bundle, appc-rest-healthcheck-adapter-bundle
  -  These properties need to be defined in order to use OpenStack-based API executions. For example, the APPC function "restart" is in charge of restarting a VM when requested. Therefore, properties such as OpenStack credentials, tenant name, VM ID, and others pre-defined in the appc.properties need to be defined with the information of the OpenStack Environment you are deploying APPC from.
  -  **Properties**:

    -  **provider1.type**:
       Default value is OpenStackProvider for OpenStack conn.
    -  **provider1.name**:
       Default value is OpenStackProvider for OpenStack conn.
    -  **provider1.identity**:
       The VIM authentication URL.
    -  **provider1.tenant1.name**:
       The Tenant Name of the VIM.
    -  **provider1.tenant1.userid / provider1.tenant1.password**:
       The VIM username and password.


-  **test.\* properties**:

  -  Applies to the following features: appc-rest-adapter-bundle, appc-chef-adapter-bundle, appc-iaas-adapter-bundle
  -  These are properties that test OpenStack-based APPC API requests

-  **Other iaas properties**:

  -  **org.onap.appc.iaas.skiphypervisorcheck**:
     Skips the hypervisor check which usually occurs during iaas-adapter-bundle startup.
  -  **org.onap.appc.server.state.change.timeout**:
     The amount of time, in seconds, that the application waits for a change of state of a server to a known valid state before giving up and failing the request.
  -  **org.onap.appc.openstack.poll.interval**:
     The amount of time, in seconds, between subsequent polls to the openstack provider to update the state of a resource.
  -  **org.onap.appc.stack.state.change.timeout**:
     The amount of time, in seconds, that the application waits for a change of state of a stacj to a known valid state before giving up and failing the request.


**Other Properties**

-  **appc.sdc.\* properties**:

  -  Used to connect to a SDC instance. Applies to the following feature: appc-sdc-listener-bundle
  -  These properties are used to test integration between the SDC ONAP component & APPC. Properties such as pointing to the DMaaP listener & topic, SDC credentials to authenticate into the SDC component, define the RESTCONF URL, and others are mapped here.

-  **restconf.user, restconf.pass properties**:

  -  Applies to the following features: appc-netconf-adapter-bundle, appc-dg-common
  -  These properties can be defined to define the RESTCONF credentials needed to execute APPC API requests from the features impacted above.

-  **org.onap.appc.provider.retry.delay / org.onap.appc.provider.retry.limit**:

  -  Applies to the following features: appc-rest-adapter-bundle, appc-iaas-adapter-bundle, appc-chef-adapter-bundle
  -  These properties are used to configure the retry logic for connection to the IaaS provider(s).  The retry delay property is the amount of time, in seconds, the application waits between retry attempts.  The retry limit is the number of retries that are allowed before the request is failed.

-  **appc.LCM.scopeOverlap.endpoint**:

  -  Applies to appc-request-handler-core
  -  Used to define the RESTCONF url of the interfaces-service
  
**APPC Transactions Database Connection**

Applies to the following features: appc-dg-common, appc-command-executor-core, appc-request-handler-core, appc-workflow-management-core.

.. code:: bash
	
	# appcctl is the default name of the APPC Database Table, equivalent to sdnctl
	org.onap.appc.db.url.appcctl=jdbc:mysql://<HOST_IP>:3306/appcctl
	org.onap.appc.db.user.appcctl=appcctl
	org.onap.appc.db.pass.appcctl=appcctl

aaiclient.properties
====================
**AAI Adaptor (SDNC-based)**

APPC connects with ONAP AAI using the SDNC AAI service (sdnc-aai-service-<VERSION_NUMBER>.zip).

To initialize AAI services on an APPC instance, the following AAI properties need to be configured in */opt/onap/appc/data/properties/aaiclient.properties*. The current default properties for AAI are located in `aaiclient.properties <https://gerrit.onap.org/r/gitweb?p=appc/deployment.git;a=blob;f=installation/src/main/properties/aaiclient.properties;h=c3cd088c2c97253ff56d341d749d5da9df385929;hb=HEAD>`_.

- **Example**:

  .. code:: bash

	org.onap.ccsdk.sli.adaptors.aai.ssl.trust=<SSL_Keystore_location> # Default value is /opt/onap/appc/data/stores/truststore.openecomp.client.jks - this default keystore currently exists in that path
	org.onap.ccsdk.sli.adaptors.aai.ssl.trust.psswd=<SSL_Keystore_Password> # Default value for the default keystore is adminadmin
	org.onap.ccsdk.sli.adaptors.aai.uri=<AAI_INSTANCE_LOCATION> # Default value is https://aai.api.simpledemo.openecomp.org:8443

appc-config-adaptor.properties
==============================

These properties provide urls and authentication for the appc config component and appc audit component services. These properties are used in the appc-config-adaptor bundle.

- **Example**:

  .. code:: bash

	configComponent.url=
	configComponent.user= 
	configComponent.passwd=
	service-configuration-notification-url= 

appc-flow-controller.properties
===============================

These properties provide urls and authentication to the sequence generator and healthcheck. Both of these are services are running in OpenDaylight.

- **Example**:

  .. code:: bash

	seq_generator_url=http://localhost:8181/restconf/operations/sequence-generator:generate-sequence
	seq_generator.uid=admin
	seq_generator.pwd=Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U
	HealthCheck.mock=true
	HealthCheck.context=/restconf/operations/appc-provider-lcm:health-check
	HealthCheck.default-rest-user=TestUser
	HealthCheck.default-rest-pass=TestPass


mdsal-resource.properties
=========================

These properties provide connection configuration for the ccsdk sli mdsal OpenDaylight feature.

- **Example**:

  .. code:: bash

	org.onap.ccsdk.sli.adaptors.resource.mdsal.sdnc-user=admin
	org.onap.ccsdk.sli.adaptors.resource.mdsal.sdnc-passwd=admin
	org.onap.ccsdk.sli.adaptors.resource.mdsal.sdnc-host=localhost
	org.onap.ccsdk.sli.adaptors.resource.mdsal.sdnc-protocol=http
	org.onap.ccsdk.sli.adaptors.resource.mdsal.sdnc-port=8181

sql-resource.properties
=======================

This file should be pre-populated with a key used by the sdnc-sql-resource feature to decrypt database data.

- **Example**:

  .. code:: bash

	org.openecomp.sdnc.resource.sql.cryptkey=

dblib.properties
================
**Database Connection**

APPC uses the SDNC dblib service (*sdnc-dblib-<VERSION_NUMBER>.zip*) for all database operations. The SQL driver used to connect to the MySQL Database is the MariaDB Driver/Connector.

This library uses the file, */opt/onap/appc/data/properties/dblib.properties*, which contains the requisite database properties, such as host, user and password. The current default properties for dblib are located in `dblib.properties <https://gerrit.onap.org/r/gitweb?p=appc/deployment.git;a=blob;f=installation/src/main/properties/dblib.properties;h=baf2f53d2900f5e1cb503951efe1857f7921b810;hb=HEAD>`_.

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


svclogic.properties
===================
**Service Logic Interpreter (SLI) - SVCLOGIC**

APPC uses the SDNC SLI service (*sdnc-sli-<VERSION_NUMBER>.zip*) to execute the DG.

To initialize SLI services, the following properties need to be configured in */opt/onap/appc/data/properties/svclogic.properties*. The database operations performed from the DG also use this database configuration. The current default properties for SLI are located in `svclogic.properties <https://gerrit.onap.org/r/gitweb?p=appc/deployment.git;a=blob;f=installation/src/main/properties/svclogic.properties;h=7900843184eb41f518156e6f285d21adce5fae2e;hb=HEAD>`_.

.. code:: bash
	
	org.onap.ccsdk.sli.dbtype = jdbc

	# Note : the next 4 fields are only used if org.onap.ccsdk.sli.dbtype = jdbc
	org.onap.ccsdk.sli.jdbc.url=jdbc:mysql://<HOST_IP>:3306/<DB_NAME> # jdbc:mysql://localhost:3306/sdnctl
	org.onap.ccsdk.sli.jdbc.database=<DB_NAME> # e.g. sdnctl
	org.onap.ccsdk.sli.jdbc.user=<USER> # e.g. sdnctl
	org.onap.ccsdk.sli.jdbc.password=<PASSWORD>

designService.properties
========================

APPC uses design-services to support the Controller Design Tool

To configure design services to work correctly, the following properties need to be configured in */opt/onap/appc/data/properties/designService.properties*. The current default properties for design services is located in `designService.properties <https://gerrit.onap.org/r/gitweb?p=appc/deployment.git;a=blob;f=installation/src/main/properties/designService.properties;h=7900843184eb41f518156e6f285d21adce5fae2e;hb=HEAD>`_.

.. code:: bash
	
	appc.upload.user=<USER> //Eg: admin
	appc.upload.pass=<PASSWORD> //Eg: admin
	appc.upload.provider.url=<RestConf End Point for Artifact handler:uploadArtifact> // Eg:http://localhost:8181/restconf/operations/artifact-handler:uploadartifact
