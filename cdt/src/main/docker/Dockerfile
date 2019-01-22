# ============LICENSE_START==========================================
# ONAP : APPC
# ===================================================================
# Copyright (C) 2018 AT&T Intellectual Property. All rights reserved.
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
# ============LICENSE_END============================================

# Base Alpine with added packages needed for ONAP
FROM httpd:2.4-alpine
MAINTAINER APP-C Team (appc@lists.openecomp.org)

COPY config-design-tool /usr/local/apache2/htdocs/

RUN mkdir /opt

COPY startCdt.sh /opt
