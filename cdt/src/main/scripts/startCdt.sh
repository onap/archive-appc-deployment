#!/bin/sh

###
# ============LICENSE_START=======================================================
# APPC
# ================================================================================
# Copyright (C) 2018-2019 AT&T Intellectual Property. All rights reserved.
# ================================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============LICENSE_END=========================================================
###

CDT_PORT=${CDT_PORT:-30232}
echo "Setting CDT port to $CDT_PORT"
sed -i -e "s/30290/$CDT_PORT/" /opt/cdt/main.bundle.js

CDT_HOME=/opt/cdt; export CDT_HOME
LOG_DIR=/opt/cdt/logs; export LOG_DIR
MaxLogSize=3000000; export MaxLogSize
PORT=18080; export PORT
HTTPS_KEY_FILE=/opt/cert/cdt-key.pem; export HTTPS_KEY_FILE
HTTPS_CERT_FILE=/opt/cert/cdt-cert.pem; export HTTPS_CERT_FILE
node $CDT_HOME/app/ndserver.js 2>&1 >/dev/null
