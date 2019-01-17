# ============LICENSE_START==========================================
# ONAP : APPC
# ===================================================================
# Copyright (C) 2017-2019 AT&T Intellectual Property. All rights reserved.
# ===================================================================
#
# Unless otherwise specified, all software contained herein is licensed
# under the Apache License, Version 2.0 (the License);
# you may not use this software except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ECOMP is a trademark and service mark of AT&T Intellectual Property.
# ============LICENSE_END============================================

# Base ubuntu with added packages needed for ONAP
FROM onap/ccsdk-odlsli-image:0.3.3
MAINTAINER APP-C Team (appc@lists.openecomp.org)

# Set the Env. Variable in the container to add the APPC CONFIG DIR (the SDNC_CONFIG_DIR is inherited from SDNC Image)
ENV APPC_CONFIG_DIR /opt/onap/appc/data/properties

# Copy the opt folder to the container's /opt folder
COPY opt /opt

#Copy the directory containing each features' install script
COPY featureDir /opt/onap/appc/features

#Copy the directory containing a system folder and an etc folder in order
#  to merge both of these with the opendaylight folders of the same names.
COPY repoDir /opt/opendaylight


RUN ln -s /opt/onap/appc /opt/appc

#Start opendaylight and pre-install the appc features
RUN opt/onap/appc/bin/dockerInstall.sh

# Expose port 8181 for ODL REST calls
EXPOSE 8181
