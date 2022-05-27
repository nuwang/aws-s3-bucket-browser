#!/bin/bash

cd /cvmfs/data.galaxyproject.org/
find . -maxdepth 2 | sort | awk '$0 !~ last "/" {print last} {last=$0} END {print last}' | grep "\S" | jq -R '[.]' | jq -s -c 'add'
