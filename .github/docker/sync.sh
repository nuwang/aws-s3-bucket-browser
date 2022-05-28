#!/bin/bash

set -xe

# mount cvmfs and s3
/app/mount.sh

printf \nMirroring cvmfs to s3
export CVMFS_PATH=/cvmfs/data.galaxyproject.org/$1
export S3FS_PATH=/opt/s3fs/galaxy/v1/data.galaxyproject.org/$1
ls $CVMFS_PATH | xargs -n1 -P8 -I% rsync --progress -avh --exclude=".*" $CVMFS_PATH/%/ $S3FS_PATH/%/ -delete

printf \nMake all symlinks geesefs compatible
find /opt/s3fs/galaxy/v1/data.galaxyproject.org/$1 -type l -ls | awk '{print substr($11, 11) " " $13}'  | xargs -n2 -P8 bash -c 's3cmd modify --add-header "x-amz-meta---symlink-target:$1" s3://biorefdata/$0' || echo "No files found or error"

printf Done!
