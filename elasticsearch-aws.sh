#!/bin/bash

set -ex

AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
REGION=${AZ:0:${#AZ}-1}
MAC=$(curl -s http://169.254.169.254/latest/meta-data/mac)
SG=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/${MAC}/security-groups)
IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

CLIENT_PORT=${CLIENT_PORT:-9200}
CLUSTER_NAME=${CLUSTER_NAME:-unnamedcluster}
NODE_NAME=${IP//./-}

chown elasticsearch /usr/share/elasticsearch/data

gosu elasticsearch elasticsearch \
  -E cluster.name=${CLUSTER_NAME} \
  -E node.name="ip-${NODE_NAME}" \
  -E network.host=${IP} \
  -E http.port=${CLIENT_PORT} \
  -E discovery.zen.hosts_provider=ec2 \
  -E discovery.ec2.groups="${SG}" \
  -E cloud.aws.region=${REGION} \
  -E thread_pool.index.queue_size=${IDX_QUEUE_SIZE} \
  $@
