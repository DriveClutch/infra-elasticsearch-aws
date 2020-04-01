#!/bin/bash

set -e

AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
REGION=${AZ:0:${#AZ}-1}
MAC=$(curl -s http://169.254.169.254/latest/meta-data/mac)
SG=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/${MAC}/security-groups)
IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
S3REPOSETTINGS="'{
   "type":"s3",
   "settings":{
      "bucket":"com.driveclutch.production.es-index-storage",
      "base_path":"telematics",
      "access_key":"ACCESS_KEY",
      "secret_key":"SECRET_KEY"
   }
}
'"

CLIENT_PORT=${CLIENT_PORT:-9200}

chown elasticsearch /usr/share/elasticsearch/data

gosu elasticsearch elasticsearch \
  --network.publish_host=${IP} \
  --http.port=${CLIENT_PORT} \
  --discovery.type=ec2 \
  --discovery.ec2.groups=${SG} \
  --cloud.aws.region=${REGION} \
  --cloud.aws.protocol=https

curl -X PUT localhost:${CLIENT_PORT}/_snapshot/my_s3_repository?pretty -H "Content-Type: application/json" -d "${S3REPOSETTINGS}"