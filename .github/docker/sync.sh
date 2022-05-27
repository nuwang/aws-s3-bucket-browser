#!/bin/bash

set -xe

# mount cvmfs and s3
/app/mount.sh

printf \nMirroring cvmfs to s3
rsync --progress -avh --exclude=".*" /cvmfs/data.galaxyproject.org/$1/ /opt/s3fs/galaxy/v1/data.galaxyproject.org/$1/

printf \nMake all symlinks geesefs compatible
find /opt/s3fs/galaxy/v1/data.galaxyproject.org/$1 -type l -ls | awk '{print substr($11, 11) " " $13}'  | xargs -l bash -c 's3cmd modify --add-header "x-amz-meta---symlink-target:$1" s3://biorefdata/$0' || echo "No files found or error"

printf Done!
