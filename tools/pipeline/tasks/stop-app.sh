#!/bin/bash

set -eu

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
        cf stop $app
    done;
done;
