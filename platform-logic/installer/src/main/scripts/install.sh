#!/bin/bash

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

