#!/bin/bash

###
# ============LICENSE_START=======================================================
# openECOMP : APP-C
# ================================================================================
# Copyright (C) 2017 OpenECOMP
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

# BASEDIR env variable points to /opt/openecomp/appc/svclogic
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"


# Load directed graphs
for graphlist in $(find $BASEDIR/graphs -name graph.versions -print)
do
  curdir=$(dirname $graphlist)

  # Load files from directory containing graph.versions file
  echo "Loading APP-C Directed Graphs from $curdir"
  for file in $(ls $curdir/*.xml)
  do
    echo "Loading $file ..."
    $BASEDIR/bin/svclogic.sh load $file $BASEDIR/config/svclogic.properties
  done

  # Activate directed graphs
  while read module rpc version mode
  do
     echo "Activating APP-C DG $module $rpc $version $mode"
     $BASEDIR/bin/svclogic.sh activate $module $rpc $version $mode $BASEDIR/config/svclogic.properties
  done < <(cat $graphlist)
done

