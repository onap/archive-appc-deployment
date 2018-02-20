/*
* ============LICENSE_START==========================================
* ===================================================================
* Copyright (C) 2017-2018 AT&T Intellectual Property. All rights reserved.
* ===================================================================
*
* Unless otherwise specified, all software contained herein is licensed
* under the Apache License, Version 2.0 (the "License";
* you may not use this software except in compliance with the License.
* You may obtain a copy of the License at
*
*             http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
*
*
* Unless otherwise specified, all documentation contained herein is licensed
* under the Creative Commons License, Attribution 4.0 Intl. (the "License");
* you may not use this documentation except in compliance with the License.
* You may obtain a copy of the License at
*
*             https://creativecommons.org/licenses/by/4.0/
*
* Unless required by applicable law or agreed to in writing, documentation
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
* ============LICENSE_END============================================
*
* ECOMP is a trademark and service mark of AT&T Intellectual Property.
*
*/
# ONAP APP-C - Available Properties

---
---

# Introduction

The current list of properties that can be overwritten from all default.properties files to appc.properties (./src/main/appc-properties/appc.properties) are list below. Please note that some properties have default values since some code requires it to be defined as part of the building/compilation process. 

- NOTE: The only defined property values in appc.properties are the following:
    - "appc.ClosedLoop1607.*" properties (needed for demo)
    - "appc.provider.vfodl.url" property (needed for demo)
    - "appc.service.logic.module.name" property (needed for demo)
    - "appc.topology.dg.*" properties (needed for demo)

# Properties List
The following properties are ready to be defined based on which feature needs to be tested or used:

- provider1.* properties:
    - Applies to the following features: appc-rest-adapter-bundle, appc-chef-adapter-bundle, appc-iaas-adapter-bundle
    - These properties need to be defined in order to use OpenStack-based API executions. For example, the APP-C function "restart" is in charge of restarting a VM when requested. Therefore, properties such as OpenStack credentials, tenant name, VM ID, and others pre-defined in the appc.properties need to be defined with the information of the OpenStack Environment you are deploying APP-C from.

- dmaap.poolMembers property:
    - Applies to the following features: appc-command-executor-core, appc-license-manager-core, appc-lifecycle-management-core, appc-request-handler-core, and appc-workflow-management-core (all part of the appc-dispatcher package)
    - Defines the DMaaP IP or URL location of the DMaaP Pool Members involved in the DMaaP Communication of that feature in specific (NOTE: More than one Pool Member can be defined in the form of a comma-delimited list)

- appc.ClosedLoop.* properties:
    - Applies to the following feature: appc-event-listener-bundle (both in src/main and src/test)
    - These properties define in which DMaaP will the appc-event-listener feature will listen in

- appc.LCM.* properties:
    - Applies to the following feature: appc-event-listener-bundle (in src/test only)
    - These properties define in which DMaaP will the appc-event-listener feature will listen in. These properties are especifically used to define LCM (LifeCycle Management) actions, and are only used as part of JUnit Test Cases.

- test.* properties:
    - Applies to the following features: appc-rest-adapter-bundle, appc-chef-adapter-bundle, appc-iaas-adapter-bundle
    - These are properties that test OpenStack-based APP-C API requests

- appc.asdc.*:
    - Applies to the following feature: appc-asdc-listener-bundle
    - These properties are used to test integration between the SDC ONAP component & APP-C. Properties such as pointing to the DMaaP listener & topic, SDC credentials to authenticate into the SDC component, define the RESTCONF URL, and others are mapped here.

- Other properties:
    - poolMembers, event.pool.members, restconf.user, restconf.pass
        - Applies to the following features: appc-netconf-adapter-bundle, appc-dg-common, appc-dmaap-adapter-bundle
        - These properties can be defined to use the features defined above. They are used to point to current DMaaP listener, and to define the RESTCONF credentials needed to execute APP-C API requests from the features impacted above.
