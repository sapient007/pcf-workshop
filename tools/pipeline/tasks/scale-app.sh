#!/bin/bash

set -eu

CF_API_URI="api.run.haas-83.pez.pivotal.io"
CF_USERNAME="admin"
CF_PASSWORD="QEshW95tx0iI_XYZ5I3pP86-95Q5coZz"
ORG="workshop"
INSTANCES="1"

cf api $CF_API_URI --skip-ssl-validation
cf auth $CF_USERNAME $CF_PASSWORD
cf target -o $ORG

set -e
#find all spaces order ORG
cf spaces |awk '/name/{y=1;next}y' | while read -r line; do
    echo "processing space $line"
    cf target -o $ORG -s $line
    echo "find all running apps in space"
    cf apps | awk '/name/{y=1;next}y' | awk '{print $1}'| while read -r app; do
        echo "---scale $app to $INSTANCES----"
        cf scale -i $INSTANCES $app
    done;
done;
