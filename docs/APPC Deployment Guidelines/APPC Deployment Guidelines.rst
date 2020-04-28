.. ============LICENSE_START==========================================
.. ===================================================================
.. Copyright © 2017-2020 AT&T Intellectual Property. All rights reserved.
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

==========================
APPC Deployment Guidelines
==========================

Introduction
============

The Application Controller (APPC) is one of the components in the ONAP
Platform. Its main function is to perform functions to control the
lifecycle of Virtual Functions (VNFs) as well as the components that
make up these functions. Therefore, this allows the cloud to be
abstracted from Virtual Functions in order to enable repeatable actions,
as well as enabling automation and a dynamic configuration approach.

ONAP APPC is delivered either as as a Kubernetes based Cloud Native
deployment or as an OpenStack deployment with **4 Docker Containers**,
which are deployed using Docker Images already containing the APPC
Framework Suite.

Deployment Mode for APPC
========================

The docker containers described above are set up to be deployed on the
same Virtual Machine. **Docker Compose** is Docker's deployment tool
that allows to configure and deploy multiple containers at once.

Deploying APPC
==============

Appc runs on a series of Docker containers. In production, these Docker
containers are run as part of a Kubernetes cluster using Helm charts,
but the Docker containers can be brought up without using Kubernetes
(using docker-compose), for the purposes of testing.

APPC Docker Containers
----------------------

Pre-built ONAP APPC docker images are stored on the LF Nexus 3 server
(nexus3.onap.org). Snapshot docker images contain snapshot versions of
appc components. They are updated daily. These can be found in the
snapshots repository on Nexus 3. The release docker images contain only
released versions of appc components, and once a release docker image is
created, it will not change. These can be found in the releases repository
of Nexus 3.

The following Docker images are the actual deployment images used for
running APPC:

-  **APPC Container**: This Docker container carries the APPC Core
   Framework (OpenDaylight, Karaf, OSGI Bundles, ODL Functions/APIs, and
   APPC specific features). This image is built on top of the SDN-C
   Docker Image, which contains core features (such as dblib as the
   Database Connector, SLI - the Service Logic Interpreter, and the
   Active & Available Inventory (A&AI) Listener). Some of these
   inherited SDN-C features/artifacts are necessary dependencies to
   build and compile APPC features/artifacts.
-  **APPC CDT Container**: This docker container hosts the CDT front-end
   gui using nodejs. The artifacts that are contained in this docker container
   come from the appc/cdt repository.
-  **Maria DB Container (Version 10.1.11)**: This is the database for APPC.
   It’s made by the original developers of MySQL and guaranteed to stay 
   open source.
-  **Ansible Server Container**: This ansible server is for VNF owner 
   to write playbook using APPC to send LCM API command.
-  **Node Red / DGBuilder**: This container has the visual tool used to
   assemble DGs in order to put together flows or services used to serve
   Virtual Functions. NOTE: This container is deployed using a Docker
   Image that is managed and supported by the SDN-C component.

Running APPC Containers
=======================

The following steps are needed to deploy and start ONAP APPC:

Preparing your Docker environment
---------------------------------

-  The VM where APPC will be started needs to have Docker Engine and
   Docker-Compose installed (instructions on how to set Docker Engine
   can be found
   `here <https://docs.docker.com/engine/installation/>`__).
   
-  The Nexus repository certificate must be added to the
   /usr/local/share/ca-certificates/ path
   
-  You must login to the Nexus repository using this command:

   .. code:: bash
   
       docker login nexus3.onap.org:10001

Downloading the Docker Compose File
----------------------------------

The docker-compose file is needed to setup and start the docker containers.
This file, "docker-compose.yml", is located in the "docker-compose"
directory of the appc/deployment repository.

You can clone this repository to your docker host:

.. code:: bash

    git clone "https://gerrit.onap.org/r/appc/deployment"

Downloading the APPC Docker Images
----------------------------------

Several images need to be dowloaded from nexus for the full appc install:
appc-image, appc-cdt-image, ccsdk-dgbuilder-image, and ccsdk-ansible-server-image.

The command to pull an image is:

.. code:: bash

    docker pull nexus3.onap.org:10001/onap/<image name>:<image version>
    
    You can find the versions of the images that you want to download in Nexus,
    then download them with the above command.

Re-Tagging the Docker Images
----------------------------

The docker images that you downloaded from nexus will need to be re-tagged to match
the image names that the docker-compose file is looking for. If you open the
docker-compose.yml file, you'll see the image names, for example "onap/appc-image:latest".

First, check the list of images you have downloaded:

.. code:: bash

    docker images

Find the version of the image you want to tag in the output and note the image id. Run this command to tag
that image. In this example, we are tagging a version of the "appc-image".

.. code:: bash

    docker tag <image-id> onap/appc-image:latest

Repeat this process for the other images in the docker-compose file that you want to bring up.

Starting the Docker Containers
------------------------------

In order to run docker-compose commands, you need to be in the same directory that your
docker-compose.yml is located in.

In order to create and start the appc Docker containers, run this command:

.. code:: bash

    docker-compose up -d

You can see the status of all Docker containers on your host with this:

.. code:: bash

    docker ps -a

You can check the progress of the appc container start-up by viewing the Docker logs:

.. code:: bash

    docker-compose logs

When you see "Total Appc install took:" in the log, the appc install has finished.

Stopping the Docker Containers
------------------------------

A Docker container can be stopped with this command:

.. code:: bash

    docker stop <container name or id>

The container can be deleted with this command:

.. code:: bash

    docker rm -v <container name or id>

(make sure you use the -v parameter or the volume will not be removed)


Other Useful Docker Management Commands
---------------------------------------

.. code:: bash

    # Check out docker container's current details
    docker inspect <DOCKER_CONTAINER>

    # Verbose output during docker-compose commands
    docker-compose --verbose <DOCKER_COMPOSE_CMD_ARG>
    
    #Stop all running docker containers
    docker ps | while read a b c d e f g; do docker stop $a; done
    
    #Remove all docker containers (but not the images you have downloaded)
    docker ps -a | while read a b c d e f g; do docker rm -v $a; done


ONAP Heat Template
------------------

A Heat template that can be used on RackSpace to spin up the APPC Host
VM as well as the other ONAP Components is available in gitlab. This
template would orchestrate the deployment of all ONAP components, which
will trigger docker instantiation techniques to start up the containers
(either standard docker or docker-compose - depending on how the
component's containers get spun up).

Validating APPC Installation
============================

The Appc application runs as a series of OSGI features and bundles in Opendaylight on the
Appc docker container. You can confirm that Appc installed by making sure these features
show up in the Opendaylight console.

Accessing docker containers
---------------------------

The following command is used to log in / access the Appc Docker container and start a shell session:

.. code:: bash

    docker exec -it appc_controller_container bash

Checking if APPC Features are installed successfully
----------------------------------------------------

The following commands are used to check if the APPC Bundles
and Features have been installed correctly in ODL (make sure to enter
the APPC Docker Container shell session first):

.. code:: bash

    # All commands are done inside the appc docker container

    # Enter the ODL Karaf Console
    /opt/opendaylight/current/bin/client

    # Check if features have been installed or not (the ones with an 'X' in the "Installed" column have been successfully installed)
    feature:list | grep appc # filter appc features only

    # Check if bundles have been loaded successfully (the ones with 'Active' in the "State" column have been successfully loaded)
    bundle:list | grep appc # filter appc bundles only

    # Check reason why bundle failed to load
    bundle:diag <bundle id>

Accessing the API Explorer
--------------------------

The API Explorer is a GUI provided by OpenDaylight Open Source
Framework. This GUI is very useful to send API calls from APIs that are
either developed by APPC or SDN-C frameworks. In order to make these
REST calls, some APIs use the
`RESTCONF <http://sdntutorials.com/what-is-restconf/>`__ protocol to
make such calls.

In order to access this GUI, you need to go to the following website
which will prompt for ODL user credentials in order to authenticate
(more details on generic API Explorer
`here <https://wiki.opendaylight.org/view/OpenDaylight_Controller:MD-SAL:Restconf_API_Explorer>`__):

-  http://localhost:8282/apidoc/explorer/index.html (localhost can be replaced with the ip of your
   Docker host, if it is not on localhost).

APPC Configuration Model
========================

APPC Configuration model involves using "default.properties" files
(which are usually located in each of the APPC Features -
..//src//resources/org/onap/appc/default.properties) for APPC
Feature that have default (or null) property values inside the core APPC
code. These default (or null) properties should be overwritten in the
properties file called "appc.properties" located in the APPC Deployment
code (../installation/src/main/appc-properties/appc.properties).

Each APPC component depends on the property values that are defined for
them in order to function properly. For example, the APPC Feature
"appc-rest-adapter" located in the APPC Core repo is used to listen to
events that are being sent and received in the form of DMaaP Messages
through a DMaaP Server Instance (which is usually defined as a RESTful
API Layer over the Apache Kafka Framework). The properties for this
feature need to be defined to point to the right DMaaP set of events to
make sure that we are sending and receiving the proper messages on
DMaaP.

Temporary changes to the appc.properties file can be made by entering the Appc
Docker container and modifying the /opt/onap/appc/properties/appc.properties file.
Then, from outside the Docker container, you should stop and then restart the Appc
Docker container with these commands:

.. code:: bash

    docker stop appc_controller_container

    docker stop appc_controller_container


Additional Notes
================

-  For more information on a current list of available properties for
   APPC Features, please go to README.md located in the installation
   directory path of the APPC Deployment Code.
-  More documentation can be found in ONAP's `Read the
   docs <http://onap.readthedocs.io/en/latest/release/index.html#projects>`__
   documentation site.
