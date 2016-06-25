FROM driveclutch/infra-elasticsearch:2.3
MAINTAINER David Hallum <david@driveclutch.com>

RUN plugin install elasticsearch/elasticsearch-cloud-aws/2.7.1

COPY elasticsearch-aws.sh /elasticsearch-aws.sh
CMD ["/elasticsearch-aws.sh"]
