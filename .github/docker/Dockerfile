FROM ubuntu:20.04 as stage1

ARG DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED 1
ENV AWS_ACCESS_KEY_ID=""
ENV AWS_SECRET_ACCESS_KEY=""
ENV AWS_BUCKET_NAME=biorefdata
ENV AWS_BUCKET_NAME=biorefdata
ENV AWS_ENDPOINT=https://s3-ap-southeast-2.amazonaws.com
ENV AWS_REGION=ap-southeast-2

RUN set -xe; \
    apt-get -qq update && apt-get install -y --no-install-recommends \
        ansible \
        autofs \
        gnupg \
        s3cmd \
        rsync \
    && apt-get autoremove -y && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/*

# Set working directory to /app/
WORKDIR /app/

ADD . .

RUN ansible-galaxy install -r cvmfs-client-requirements.yaml -p roles && \
    # remove the autofs validation lines as we don't have /dev/fuse mounted at build time
    sed -i.bak -e '18,22d;26,27d' ./roles/galaxyproject.cvmfs/tasks/client.yml && \
    ansible-playbook -i cvmfs-client-hosts.ini cvmfs-client-playbook.yaml

RUN wget https://media.githubusercontent.com/media/maresb/docker-build-s3fs/master/builds/s3fs_1.91+git-v1.91-3_amd64.deb && \
    dpkg -i s3fs_1.91+git-v1.91-3_amd64.deb && \
    mkdir /opt/s3fs

CMD /app/sync.sh
