FROM driveclutch/infra-elasticsearch:2.3
MAINTAINER david@driveclutch

RUN plugin install cloud-aws

COPY elasticsearch-aws.sh /elasticsearch-aws.sh
CMD ["/elasticsearch-aws.sh"]
