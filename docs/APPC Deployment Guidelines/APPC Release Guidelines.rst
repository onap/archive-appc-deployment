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

=============
Building APPC
=============

Introduction
============

This document will go over how to perform an official APPC release on ONAP. This document only applies to PTLs and
committers, since certain permissions are required to perform an official release.

Releasing the APPC Parent Files
===============================

First we will release the APPC parent files, since they are used by the main APPC project. Release version for the
parent files start with a "2". For example, "2.7.1". This keeps the parent version differentiated from the other APPC
versions, which start with a "1".

1. Go to the appc/parent Gerrit page.
2. Find the most recent gerrit review that has been merged. Leave a comment on this review with the words:
   "stage-maven-release". This will trigger the staging job.
3. Check the Jenkins job `appc-parent-maven-stage-master <https://jenkins.onap.org/view/appc/job/
   appc-parent-maven-stage-master/>`_. You can monitor the staging build job from here.
4. Once the Jenkins build job is finished, note the number of that build job.
5. Open your local copy of the appc/parent repository. Go to the "releases" directory.
6. Copy one of the existing release files in that directory. Rename the new file with the version number that you are
   releasing.
7. Open the new file. Update the "version:" with the version number that you are releasing. Update the "log_dir:" with
   the Jenkins job number from step 4.
8. Commit and push this new file to Gerrit. You can use a commit title like "Add 2.7.1 release file" or something
   similar.
9. Once this change is merged in Gerrit, a new release for org.onap.appc.parent will be created in Nexus.

Releasing the Main APPC Project
===============================

1. First, references to the appc parent files need to be set to match the version of the parent files that you just
   released, rather than a snapshot version. You can search for the text "org.onap.appc.parent" in all of the pom.xml
   files in the appc repository. Perform a find/replace on entire version tag "<version>...</version>" for the parent
   file in order to update the APPC parent version.
2. Commit and push this change to Gerrit. Merge the change.
3. Once the merge is complete, leave a comment on the review with the text "stage-maven-release". (This is assuming that
   your parent change was the lastest change merged, if it was not, leave the "stage-maven-release" comment on
   whichever review was most recently merged).
4. Check the Jenkins job `appc-maven-stage-master <https://jenkins.onap.org/view/appc/job/appc-maven-stage-master/>`_.
   You can monitor the staging build job from here.
5. Once the Jenkins build job is finished, note the number of that build job.
6. Open your local copy of the appc repository. Go to the "releases" directory.
7. Copy one of the existing release files in that directory. Rename the new file with the version number that you are
   releasing.
8. Open the new file. Update the "version:" with the version number that you are releasing. Update the "log_dir:" with
   the Jenkins job number from step 4.
9. Commit and push this new file to Gerrit. You can use a commit title like "Add 1.7.1 release file" or something
   similar.
10. Once this change is merged in Gerrit, a new release for org.onap.appc will be created in Nexus. 

Releasing the APPC CDT Project
==============================

1. Go to the appc/cdt Gerrit page.
2. Find the most recent gerrit review that has been merged. Leave a comment on this review with the words:
   "stage-maven-release". This will trigger the staging job.
3. Check the Jenkins job `appc-cdt-maven-stage-master <https://jenkins.onap.org/view/appc/job/
   appc-cdt-maven-stage-master/>`_. You can monitor the staging build job from here.
4. Once the Jenkins build job is finished, note the number of that build job.
5. Open your local copy of the appc/cdt repository. Go to the "releases" directory.
6. Copy one of the existing release files in that directory. Rename the new file with the version number that you are
   releasing.
7. Open the new file. Update the "version:" with the version number that you are releasing. Update the "log_dir:" with
   the Jenkins job number from step 4.
8. Commit and push this new file to Gerrit. You can use a commit title like "Add 1.7.1 release file" or something
   similar.
9. Once this change is merged in Gerrit, a new release for org.onap.appc.cdt will be created in Nexus.

Releasing the APPC Docker Images
================================

Update the APPC Artifact Download Versions
------------------------------------------

The following operations should be performed in your local copy of the appc/deployment repository.

1. Open the "installation/appc/pom.xml" file.

   a. Set the "<appc.release.version>" property to the version of APPC that you just released.
   b. Set the "<appc.cdt.version>" property to the version of APPC CDT that you just released.
   
2. Open the "cdt/pom.xml" file.

   a. Set the "<appc.release.version>" to the version of APPC CDT that you just released.
   
3. Open the "installation/appc/src/main/docker/Dockerfile" file.

   a. Make sure that the ccsdk image version listed on the "FROM" line is set to the released (non snapshot) version of
      ccsdk that you want to use to build APPC on.
      
4. Commit and push these changes to Gerrit. Merge the change, once the verify job completes.

Prepare to Release the Docker Images
------------------------------------

1. Go to the appc/deployment Gerrit page.
2. Find the most recent gerrit review that has been merged. Leave a comment on this review with the words:
   "stage-docker-release". This will trigger the staging job.
3. Check the Jenkins job `appc-deployment-maven-docker-stage-master <https://jenkins.onap.org/view/appc/job/
   appc-deployment-maven-docker-stage-master/>`_. You can monitor the docker staging build job from here.
4. Once the Jenkins build job is finished, note the number of that build job.
5. Open the "Console Output" for the build job. You may need to click the "Full Log" link to see the whole log.
6. Search the page for the text "tag 2". Copy the tag text (this should be the tag with the date time stamp).

Check the Docker Images Before Release
--------------------------------------

Optionally, you can download the staged Docker images, and make sure everything is correct, before releasing them.

You can use the Docker tag you copied from Jenkins (from step 6 of the "Prepare to Release the Docker Images" section)
and download this Docker image:

.. code:: bash

  docker pull nexus3.onap.org:10001/onap/appc-image:<image tag from Jenkins>
  docker pull nexus3.onap.org:10001/onap/appc-cdt-image:<image tag from Jenkins>
  
Release the Docker Images
-------------------------

1. Open your local copy of the appc/deployment repository. Go to the "releases" directory.
2. Copy one of the existing release files in that directory. Rename the new file with the version number that you are
   releasing, followed by the text "-container".
3. Open the new file.

   a.Update the "container_release_tag:" with the version number that you are releasing.
   a. Update the "log_dir:" with the Jenkins appc-deployment-maven-docker-stage-master job number that built the staging
      images (from step 4 of the "Prepare to Release the Docker Images" section).
   b. Update the "ref:" with the git commit id of the Gerrit review where you made the "stage-docker-release" comment.
      (from step 2 of the "Prepare to Release the Docker Images" section).
   c. Under the "containers:" section, update both "version:" with the image tag from Jenkins (from step 6 of the 
      "Prepare to Release the Docker Images" section).
      
4. Commit and push this new file to Gerrit. You can use a commit title like "Add 1.7.1 container release file" or
   something similar.
5. Once this change is merged in Gerrit, the appc-image and appc-cdt-image Docker images will be released in Nexus 3 




