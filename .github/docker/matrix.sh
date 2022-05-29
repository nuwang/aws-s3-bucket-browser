#!/bin/bash

# Find all subdirectories at depth 2 and sort them, use awk to remove any parent directories, use cut to remove the
# prefix (/cvmfs/data.galaxyproject.org), use grep to remove empty lines and use jq to convert the resultant list
# to a javascript array of directories.
find /cvmfs/data.galaxyproject.org/ -maxdepth 2 -type d | sort | awk '$0 !~ last "/" {print last} {last=$0} END {print last}' | cut -c 31- | grep "\S" | jq -R '[.]' | jq -s -c 'add'
