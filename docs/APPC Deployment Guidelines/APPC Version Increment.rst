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

========================================
Incrementing APPC Versions After Release
========================================

Version Numbers
===============

The version number for APPC is composed of 3 numbers. For example, "2.7.1-SNAPSHOT".

The first number stays the same. For appc/parent, the first number is a "2". For the other APPC projects, it is a "1".

The second number is the number of the ONAP release. For example, all releases done for the ONAP "Beijing" release will
have the same number here.

The third number is the minor version. This number is incremented by 1 for each version of APPC that we release within
one ONAP release. This number gets reset back to 0 when a new ONAP release begins.

The versions in the APPC repositories are always SNAPSHOT versions, since these versions are used for making daily
builds.

Changing Version for APPC, APPC Parent, and APPC CDT Projects
=============================================================

The process is the same for these three projects.

1. First, open a terminal window to your local git repository for the project you are working on.

2. Run the maven versions:set command to update the version of all pom files. Remember to include the word "SNAPSHOT"
   after the version number:

   .. code:: bash

     mvn versions:set -DgenerateBackupPoms=false -DnewVersion=<the new version number>

3. Open the "version.properties" file, located in the root directory of the repository. You will see three rows with
    numbers. Update these numbers to match your version number (you do not need to use the word SNAPSHOT here).

4. Use git to commit and push all of the changed files. You can use a commit title like
   "Increment version to <new version>" or something similar.

Changing the Parent Version in the APPC Project to Snapshot
-----------------------------------------------------------

As you make changes to the appc/parent repository, you will need to update the main APPC project to use this snapshot
version of appc/parent, instead of the previous released version, in order to pick up changes. You can search for the
text "org.onap.appc.parent" in all of the pom.xml files in the APPC repository. In order to change the version, a
find/replace on the <version> tag can be performed.

Changing Version for APPC Deployment Project
============================================

For the appc/deployment project, there are a few additional steps.

1. First, follow the steps 1 - 3 of the "Changing Version for APPC, APPC Parent, and APPC CDT Projects" section above.

2. Open the installation/appc/pom.xml file. Change the  "<appc.snapshot.version>" property to the new snapshot version
   of the APPC project.

3. Open the cdt/pom.xml file. Change the  "<appc.snapshot.version>" property to the new snapshot version of the
   APPC CDT project.

4. Use git to commit and push all of the changed files. You can use a commit title like
   "Increment version to <new version>" or something similar.


