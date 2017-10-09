.. This work is licensed under a Creative Commons Attribution 4.0 International License.

==============
Platform Logic
==============

Platform Logic is a SDNC-based component that was re-purposed in APPC to also be able to load Directed Graphs (DGs) into the APPC MySQL Database, especifically in the SVC_LOGIC table where all the DGs are loaded and activated for use.

In a visual perspective, a Directed Graph is a set of input/output/processing nodes (which are code blocks defining a certain logic or action) connected to each other. This ultimately forms what is denominated as a "service flow" that defines the actions to be taken for a specific APPC action (i.e. an APPC lifecycle/LCM action that restarts a VNF).

For more information on the useability and definition of a Directed Graph, SDNC's Service Logic Interpreter (SLI), and using the DG Builder (AT&T version of Node-RED - also one of APPC's docker containers), please visit the `Service Logic Interpreter Directed Graph Guide <https://wiki.onap.org/display/DW/Service+Logic+Interpreter+Directed+Graph+Guide>`__ in the ONAP Wiki.


Platform Logic - Structure
==========================

The APPC Platform Logic is based on SDNC's Platform Logic Structure, and they are both based on a maven/pom-based build structure. SDNC Platform Logic code can be found `here <https://gerrit.onap.org/r/gitweb?p=sdnc/oam.git;a=tree;f=platform-logic;h=f4a0366a45c5bad0e1e22606f7dcbe3735b68fd5;hb=HEAD>`__, and APPC Platform Logic code can be found `here <https://gerrit.onap.org/r/gitweb?p=appc/deployment.git;a=tree;f=platform-logic;h=064d6bfe5cdb8437e93a992432c4fbae2cb02931;hb=HEAD>`__. They both have the same basic structure while the main difference is that SDNC hosts the SDNC DGs and APPC hosts the APPC DGs.

The main composition of Platform Logic consists of trigerring shell scripts to call SLI java-based libraries to ultimately load and activate DGs into the MySQL Database.

-  There are two main folders that compose platform-logic:

  -  installer: This is where the shell scripts are located on and where the assembly script in XML format that takes care of defining how the platform logic bundle (in a .zip package) will be wrapped up. Since the outcome will be in the form of a ZIP file, the following items will be contained in it:

    -  Directed Graphs (in XML format)
    -  Shell Scripts needed to load and activate the Directed Graphs into the SQL Database
    -  Resources (such as the SQL scripts needed to set up VNF_DG_MAPPING table, and svclogic properties needed to point out which SQL DB to load DGs).
    -  JAR SLI libraries needed to execute the load/activation of DGs into the DB.
	  
  -  appc: This is where the DGs and its DG attribute definitions script are located at. The following items are contained in here:

    -  The DG scripts in XML format are used in conjunction with the shell scripts in the installer path to load and activate DGs into the DB.
    -  The DG scripts in JSON format are used when wanting to load and activate DGs into the DB but using nodered/dgbuilder graphic GUI (the third container deployed in APPC's docker-compose script).
    -  The `graph.versions script <https://gerrit.onap.org/r/gitweb?p=appc/deployment.git;a=blob;f=platform-logic/appc/src/main/resources/graph.versions;h=c3e8fd372bc60d180963af2e09870117debd7398;hb=HEAD>`__ that contains the DG attribute definitions (module name, version number, rpc name, and sync mode) where all this data can all be found in the DG itself. This script is then read by the install.sh script which is the one that runs the `svclogic.sh script <https://gerrit.onap.org/r/gitweb?p=appc/deployment.git;a=blob;f=platform-logic/installer/src/main/scripts/svclogic.sh;h=b9eef1e70c99ba83cdb5108791938014b94c6c86;hb=33a21fd1ddefe0044ea81686209b9d2f1ef35a41>`__ that ultimately calls some the SLI JAR and its dependencies to load and activate the DGs defined in graph.versions into the DB (NOTE: In order for a new DG to be loaded and activated properly, the attributes mentioned above need to be added in its own separate line as part of the graph.versions script).
    -  The pom.xml in here also takes care of grabbing the above items and dropping them in a specific folder path when the docker image is deployed (in this case, /opt/appc/graphs/appc path).

Loading and Activating a DG in the DB using Platform Logic
==========================================================

In order to load a DG into the DB to be loaded and activated for use, follow the next steps:

1.  Need to have the XML version of the Directed Graph script and drop it in the xml folder `here <https://gerrit.onap.org/r/gitweb?p=appc/deployment.git;a=tree;f=platform-logic/appc/src/main;hb=HEAD>`__. Take note of the module name, version number, rpc name, and sync mode inside the "service-logic" tag.

2.  Edit the graph.versions script to add the attributes found in the first step above. Make sure that once this script is modified to not leave any end of lines or spaces. Also, it is important to make sure that the script is in UNIX mode and not DOS mode or the script will not be read correctly.

Checking that the DG has been loaded and activated
==================================================

First of all, make sure that the graph.versions has been modified and the XML format of the DG is in the xml folder as pointed out above. Then, confirm that these changes have been commited and integrated into the latest release of the APPC docker image. With this latest release of the APPC docker image, there are a number of things to check:

1.  Check that the docker-compose logs show the output of the SLI JAR execution is successful by filtering in the logs as shown in the example below:

  .. code:: bash
  
	# Ex. of the logs shown when the Chef DG is loaded and activated
	[appc_controller_container ... Installing directed graphs for APP-C
	[appc_controller_container ... Loading APP-C Directed Graphs from /opt/openecomp/appc/svclogic/graphs/appc
	...
	...
	# Loading the DG into the DB
	[appc_controller_container ... Loading /opt/openecomp/appc/svclogic/graphs/appc/APPC_chef.xml ...
	[appc_controller_container ... INFO org.openecomp.sdnc.sli.SvcLogicParser - Saving SvcLogicGraph to database (module:APPC,rpc:chef,version:3.0.0,mode:sync)
	...
	...
	# Activating the DG into the DB
	[appc_controller_container ... Activating APP-C DG APPC chef 3.0.0 sync
	[appc_controller_container ... INFO org.openecomp.sdnc.sli.SvcLogicParser - Getting SvcLogicGraph from database - (module:APPC, rpc:chef, version:3.0.0, mode:sync)

2.  Once the logs show no errors related to the load/activation of the DGs in the docker logs & the docker-compose containers have been set up, go into the APPC MySQL DB container and check that the SVC_LOGIC table has the DG:

  .. code:: bash
  
	# Log into the MySQL APPC Container
	$ docker exec -it sdnc_db_container bash
	bash-4.2# mysql -u root -p  #Password is openECOMP1.0 by default
	
	# Execute SQL commands as explained below
	mysql> USE sdnctl;  #Enter the sdnctl database
	mysql> SHOW tables;  #Checks all available tables - SVC_LOGIC table is the one
	mysql> DESCRIBE SVC_LOGIC;  #shows the fields/columns in the SVC_LOGIC table within the sdnctl DB
	mysql> SELECT module,rpc,version,mode,active FROM SVC_LOGIC;  #shows all the contents of the fields pertaining to the SVC_LOGIC table - this is where the sdnc/appc DGs are at)
	
	# OUTPUT OF THE SELECT SQL CMD (WE CAN SEE THAT THE CHEF DG IS LOADED IN THE TABLE AND ACTIVATED AS SHOWN IN THE 'active' COLUMN)
	+----------+-------------------------+----------------+------+--------+
	| module   | rpc                     | version        | mode | active |
	+----------+-------------------------+----------------+------+--------+
	| APPC     | ansible-adapter-1.0     | 2.0.1          | sync | Y      |
	| APPC     | chef                    | 3.0.0          | sync | Y      |
	| APPC     | Generic_Restart         | 2.0.1          | sync | Y      |
	| APPC     | topology-operation-all  | 2.0.0          | sync | Y      |
	| Appc-API | legacy_operation        | 2.0.0.0        | sync | Y      |
	| ASDC-API | vf-license-model-update | 0.1.0-SNAPSHOT | sync | Y      |
	| sli      | healthcheck             | 0.1.0-SNAPSHOT | sync | Y      |
	+----------+-------------------------+----------------+------+--------+

	# NOTE: do NOT add the "graph" field when selecting the columns from SVC_LOGIC above since this is the actual DG blob content which is not relevant

If the table as shown above does not show the DG you have just loaded or if there is an error in the docker-compose logs, check the reason of the error and if needed, raise an JIRA issue related to it. 
