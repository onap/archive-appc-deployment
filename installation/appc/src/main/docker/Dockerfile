# ============LICENSE_START==========================================
# ONAP : APPC
# ===================================================================
# Copyright (C) 2017-2018 AT&T Intellectual Property. All rights reserved.
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
FROM onap/ccsdk-odlsli-image:0.2.1-SNAPSHOT
MAINTAINER APP-C Team (appc@lists.openecomp.org)

# Set the Env. Variable in the container to add the APPC CONFIG DIR (the SDNC_CONFIG_DIR is inherited from SDNC Image)
ENV APPC_CONFIG_DIR /opt/onap/appc/data/properties

# Copy the opt folder to the container's /opt folder
COPY opt /opt

# We are keeping the feature installers in their
# own folders in the docker staging repository.
# The number of feature directories is defined in
# the installZips.sh file.
COPY featureDir1 /opt/onap/appc/features
COPY featureDir2 /opt/onap/appc/features
COPY featureDir3 /opt/onap/appc/features
COPY featureDir4 /opt/onap/appc/features

RUN ln -s /opt/onap/appc /opt/appc

# Expose port 8181 for ODL REST calls
EXPOSE 8181
