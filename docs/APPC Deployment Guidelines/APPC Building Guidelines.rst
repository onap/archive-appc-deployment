.. ============LICENSE_START==========================================
.. ===================================================================
.. Copyright © 2020 AT&T Intellectual Property. All rights reserved.
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
.. ECOMP is a trademark and service mark of AT&T Intellectual Property.

=============
Building APPC
=============

Introduction
============

Building of the Appc containers requires a several steps to be performed. Appc is comprised of several repositories
which must be built in order, since they depend on each other.

Here is a quick overview of the appc repositories:

- **appc/parent:** The maven parent pom files for the rest of the appc projects are kept here. This repository needs to
  be built first, since these parent pom files are referenced by other appc repositories.
  
- **appc:** The main Java code for appc is kept here. This repository should be build after building the appc/parent
  repository.

- **appc/cdt:** This repository contains two parts. The "CdtProxyService" directory contains Java code for the proxy
  service which recieves requests from the CDT application. The rest of the code in the appc/cdt project is Angular/JS
  code for the APPC CDT front end gui. Both parts will be build as part of a maven build on the app/cdt repository.
  
- **appc/deployment:** This repository contains the scripts to build the APPC docker containers. This repository should
  be built last, since it pulls artifacts from the appc and appc/cdt builds.
  
Cloning Code Repositories
=========================

The first step in building APPC is to clone the four appc repositories (listed above) using git.

Building APPC Parent
====================

First we'll build appc parent. From the appc/parent directory, run a maven clean install:

.. code:: bash

  mvn clean install
  
Building main APPC
==================

Before building the main appc repository, you need to make sure the version of the appc parent files matches the version
of the parent repository that you just built. You can search for the text "org.onap.appc.parent" in all of the pom.xml
files in the appc repository. Check if the version matches the version of app/parent that you just built. A find/replace
on the <version> tag can be performed, if it needs to be changed.

The appc repository can then be built with a maven clean install.

Building APPC CDT
=================

The appc/cdt repository should just be built with a maven clean install. This should build both the Java code in the
CdtProxyService, as well as the Angular code.

Building APPC Deployment (building the Docker images)
=====================================================

The appc/deployment repository will perform several build steps in order to build the APPC Docker images.

appc-image Docker Build Preparation
-----------------------------------

The appc-image build occurs first. The build begins by downloading the APPC artifacts that were created by the main appc
maven build. You need to make sure the version of APPC that will be downloaded matches the version of APPC that you
built in the previous steps, see the "Setting APPC Versions" section below.

The appc-image Docker image is built on top of the ccsdk-odlsli-alpine-image. The version of the ccsdk image that will
be used is defined in the installation/appc/src/main/docker/Dockerfile file. This image will need to be downloaded
before the Docker build is performed:

.. code:: bash

  docker pull nexus3.onap.org:10001/onap/ccsdk-odlsli-alpine-image:<image version>

Using the "docker tag" command, you should then tag the image you downloaded so that the image name exactly matches what
is shown in the Dockerfile.
(Please see the "APPC Deployment Guidelines" page for more information on setting up Docker and downloading images)


appc-cdt-image Docker Build Preparation
---------------------------------------

The appc-cd-image build will download the cdt angular code zip file that was created during your appc/cdt build earlier.
Similar to the appc-image build, you will have to make sure that the version of this zip that is being downloaded
matches the version that you built earlier, see the "Setting APPC Versions" section below for how to do this.

Setting APPC Versions
---------------------

The versions of APPC that will be downloaded by the Docker build are set in the properties section of the
installation/appc/pom.xml file.

- **<appc.snapshot.version>:** This property sets the version of APPC to download to the Docker image. This version will
  be used in any build where the appc/deployment pom versions are set to any "-SNAPSHOT" version (this will usually be
  the case for local builds).
- **<appc.release.version>:** This property sets the version of APPC to download to the Docker image. This version will
  be used in any build where the appc/deployment pom versions do NOT contain "-SNAPSHOT" version (this will usually only
  be used for the staging jobs on Jenkins).
- **<appc.cdt.version>:** This property sets the version of the APPC CDT proxy service that will be downloaded to the
  Docker image. This property should be set to the version of the appc/cdt repository that you built earlier. Or, if you
  didn't modify the CDT proxy code, you can leave this as it is, and a version will be downloaded from ONAP Nexus.
  
The version of the CDT code that will be downloaded by the Docker build is set in the properties section of the
cdt/pom.xml file

- **<appc.snapshot.version>:** This property sets the version of APPC CDT to download to the Docker image. This version
  will be used in any build where the appc/deployment pom versions are set to any "-SNAPSHOT" version (this will usually
  be the case for local builds).
- **<appc.release.version>:** This property sets the version of APPC CDT to download to the Docker image. This version
  will be used in any build where the appc/deployment pom versions do NOT contain "-SNAPSHOT" version (this will usually
  only be used for the staging jobs on Jenkins).
  
Building the Docker containers
------------------------------

A maven clean install with the profile "docker" is used to start the appc/deployment and Docker build:

.. code:: bash

  mvn clean install -P docker



