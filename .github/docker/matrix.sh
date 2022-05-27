#!/bin/bash

find /cvmfs/data.galaxyproject.org/ -maxdepth 2 | sort | awk '$0 !~ last "/" {print last} {last=$0} END {print last}' | grep "\S" | jq -R '[.]' | jq -s -c 'add'
