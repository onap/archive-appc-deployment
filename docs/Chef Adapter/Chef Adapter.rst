===============================
APPC Chef Adapter Documentation
===============================

This wiki provides  documentation regarding the design, capabilities and usage of the Chef Extension for APPC.

The Chef Extension for APPC allows management of VNFs that support Chef through the following two additions:

1. An APPC Chef Adapter 
2. Chef Directed Graph (DG)

Details of each of these two aspects are listed below:

1. **Chef Directed Graph (DG)**:

+------------+--------+
| Field      | Value  |
+============+========+ 
| module     | APPC   |
+------------+--------+
| rpc        | chef   | 
+------------+--------+
| version    | 3.0.0  | 
+------------+--------+

The inputs that the Chef DG expects are listed  below:

Table 1: Input Parameters to the Chef Directed Graph

+---------------------+-----------------------------------------------------------+------------+-------------------------------------------+
| Variable Name       |  Description	                                          | Type       | Comments                                  |
+=====================+===========================================================+============+===========================================+
| chef-server-address |	 The FQDN of the chef server	                          | Mandatory  | Should be provided by APPC.               |
+---------------------+-----------------------------------------------------------+------------+-------------------------------------------+
| chef-organization   |  The chef organization name	                          | Mandatory  | Should be provided by APPC.               |
+---------------------+-----------------------------------------------------------+------------+-------------------------------------------+
| chef-username	      |  The username of the chef organization	                  | Mandatory  | Should be provided by APPC.               |
+---------------------+-----------------------------------------------------------+------------+-------------------------------------------+
| Environment	      |  A JSON dictionary representing a Chef Environmentobject. | Optional   | To be provided in template by VNF owner.  |
|                     |  If the VNF action requires loading or modifying Chef     |            |                                           |
|                     |  environment attributes associated with the VNF, all the  |            |                                           |
|                     |  relevant information must be provided in this JSON       |            |                                           |
|                     |  dictionary in a structure that conforms to a Chef        |            |                                           |
|                     |  Environment Object.                                      |            |                                           |
+---------------------+-----------------------------------------------------------+------------+-------------------------------------------+
| Node	              |  A JSON dictionary representing  a Chef Node Object. The  | Mandatory  | To be provided in template by VNF owner.  |
|                     |  Node JSON dictionary must include the run list to be     |            |                                           |
|                     |  triggered for the desired VNF action by the push job.    |            |                                           |
|                     |  It should also include any attributes that need to be    |            |                                           |
|                     |  configured on the Node Object as part of the VNF action. |            |                                           |
+---------------------+-----------------------------------------------------------+------------+-------------------------------------------+
| NodeList	      |  Array of FQDNs that correspond to the endpoints (VMs) of | Mandatory  | To be provided in template.               |
|                     |  a VNF registered with the Chef Server that need to       |            |                                           |  
|                     |  trigger a chef-client run as part of the desired         |            |                                           | 
|                     |  VNF action.                                              |            |                                           | 
+---------------------+-----------------------------------------------------------+------------+-------------------------------------------+	
| CallbackCapable     |	 This field indicates if the chef-client run invoked by   | Optional   | To be provided in template by VNF owner.  |
|                     |  push job corresponding to the VNF action is  capable of  |            |                                           |
|                     |  posting results on a callback URL.                       |            |                                           |
+---------------------+-----------------------------------------------------------+------------+-------------------------------------------+
| RequestId           |  A unique string associated with the original request     | Optional   | To be provided by APPC.                   |
|                     |  by ONAP. This key-value pair will be provided by ONAP in |            |                                           |
|                     |  the environment of the push job request and must be      |            |                                           |
|                     |  returned as part of the POST message.                    |            |                                           |
+---------------------+-----------------------------------------------------------+------------+-------------------------------------------+
| CallbackUrl         |  Currently not used.	                                  | Optional   |			                   |
+---------------------+-----------------------------------------------------------+------------+-------------------------------------------+	
| retryTimes	      |  The retry times to query the result of chef push job.	  | Mandatory  | To be provided in template by VNF owner.  |
+---------------------+-----------------------------------------------------------+------------+-------------------------------------------+
| retryInterval	      |  The estimate duration to finish the push job. Measure    | Mandatory  | To be provided in template by VNF owner.  |
|                     |  by milliseconds.                                         |            |                                           |
+---------------------+-----------------------------------------------------------+------------+-------------------------------------------+
| GetOutputFlag	      |  Flag which indicates whether ONAP should retrieve output | Mandatory  | To be provided in template by VNF owner.  |
|                     |  generated in a chef-client run  from Node object         |            |                                           |
|                     |  attribute node[‘PushJobOutput’] for this VNF action      |            |                                           |
|                     |  (e.g in Audit).                                          |            |                                           |
+---------------------+-----------------------------------------------------------+------------+-------------------------------------------+
| PushJobFlag	      |  Flag which indicates whether ONAP should trigger         | Mandatory  | To be provided in template by VNF owner.  |
|                     |  the push job.                                            |            |                                           |
+---------------------+-----------------------------------------------------------+------------+-------------------------------------------+


Table 2: Output Variables set by chef DG

+-----------------------+-----------------------------------------------------------------+
| Variable Name	        |  Description                                                    |
+=======================+=================================================================+
| output.status.code    |  Result of the request : 400 if SUCCESS , 200 if FAILURE.       |
+-----------------------+-----------------------------------------------------------------+
| output.status.message |  If Cookbook finished, set to corresponding message.            |
|                       |  If abnormal error, reported in message.                        |
+-----------------------+-----------------------------------------------------------------+
| output.status.results |  A JSON dictionary with results corresponding to PushJobOutput. |
+-----------------------+-----------------------------------------------------------------+


Example:

|image0|


2. **APPC Chef Adapter**:

a. Environment set:

  - To connect to the chef server, APPC should load the chef server credentials.

  - The Chef server uses role-based access control to restrict access to objects—nodes, environments, roles, data bags, cookbooks, and so on. So we need load the user's private key to authenticate the permission.

APPC needs to pre-load the SSL certificate and user private key.
 
The file structure is shown below:

|image1|

*chefServerSSL.jks* file saves all the SSL certificates of chef server. In the chef server, please check the chef server setting file at */etc/opscode/chef-server.rb*. The *chef-server.rb* declares where is the SSL certificate. Find the SSL crt file and use keytool to import certificate to the key store. The password of the *chefServerSSL.jks* is "*adminadmin*"

The user private key file should be saved under */opt/appc/bvc/chef/{{CHEF SERVER FQDN}}/{{ORGANIZATION NAME}}* director and the file name should be *{{username}}.pem*.  Please make sure this user have enough permission on the chef server.

.. |image0| image:: images/image0.png
.. |image1| image:: images/image1.png
