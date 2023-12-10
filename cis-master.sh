#!/bin/bash
#cis-master.sh

total_fail=$(kube-bench run --targets master --version 1.28 --check 1.2.7,1.2.8,1.2.9 --json | jq .[].Totals.total_fail)

if [[ "$total_fail" -ne 0 ]];
    then 
        echo "CIS Benchmark Failed Master while testing for 1.2.7,1.2.8,1.2.9"
        exit 1;
    else
        echo "CIS Benchmark Passed Master for 1.2.7,1.2.8,1.2.9"
fi;
