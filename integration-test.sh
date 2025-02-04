#!/bin/bash

#integration-test.sh

sleep 5s

PORT=$(kubectl -n default get svc ${serviceName} -o json | jq .spec.ports[].nodePort)

echo $PORT
echo $applicationURL:$PORT/$applicatonURI

if [[ ! -z "$PORT" ]];
then
    response=$(curl -s $applicationURL:$PORT$applicationURI)
    http_code=$(curl -s -o /dev/null -w "%{http_code}" $applicationURL:$PORT$applicationURI)

    if [[ "$response" == 100 ]];
        then
            echo "Increment Test Passed"
        else 
            echo "Increment Test Failed"
    fi;

    if [[ "$http_code" == 200 ]];
        then 
            echo "HTTP Status Code Test Passed"
        else
            echo "HTTP Status Code is not 200"
            exit 1;
    fi;
else
    echo "The Serivce does not have a NodePort"
    exit 1
fi;