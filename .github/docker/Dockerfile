# This container must be run in privileged mode, as the fuse mount for cvmfs does not work otherwise.
FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED 1
ENV AWS_ACCESS_KEY_ID=""
ENV AWS_SECRET_ACCESS_KEY=""
ENV AWS_BUCKET_NAME=biorefdata
ENV AWS_ENDPOINT=https://s3-ap-southeast-2.amazonaws.com
ENV AWS_REGION=ap-southeast-2

RUN set -xe; \
    apt-get -qq update && \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | tee /usr/share/keyrings/cloud.google.gpg && \
    apt-get -qq update && \
    apt-get install -y --no-install-recommends \
        ansible \
        autofs \
        google-cloud-sdk \
        jq \
        rsync \
        s3cmd \
        s3fs \
        wget && \
    apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* && \
    mkdir /opt/s3fs

# Set working directory to /app/
WORKDIR /app/

ADD . .

RUN ansible-galaxy install -r cvmfs-client-requirements.yaml -p roles && \
    # remove the autofs validation lines as we don't have /dev/fuse mounted at build time
    sed -i.bak -e '18,22d;26,27d' ./roles/galaxyproject.cvmfs/tasks/client.yml && \
    ansible-playbook -i cvmfs-client-hosts.ini cvmfs-client-playbook.yaml

CMD /app/sync.sh
