#!/bin/bash

set -e

AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
REGION=${AZ:0:${#AZ}-1}
MAC=$(curl -s http://169.254.169.254/latest/meta-data/mac)
SG=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/${MAC}/security-groups)
IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

CLIENT_PORT=${CLIENT_PORT:-9200}

chown elasticsearch /usr/share/elasticsearch/data

gosu elasticsearch elasticsearch \
  --network.publish_host=${IP} \
  --http.port=${CLIENT_PORT} \
  --discovery.type=ec2 \
  --discovery.ec2.groups=${SG} \
  --cloud.aws.region=${REGION} \
  --cloud.aws.protocol=https \
  --cloud.aws.access_key=${ACCESS_KEY} \
  --cloud.aws.secret_key=${SECRET_KEY} \
  --repositories.s3.my-s3-bucket=${BUCKET_NAME} \
  --repositories.s3.base_path=${BASE_PATH}


