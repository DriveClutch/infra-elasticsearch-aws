FROM driveclutch/infra-elasticsearch:5.0.1
MAINTAINER David Hallum <david@driveclutch.com>

RUN elasticsearch-plugin install repository-s3 \
    && elasticsearch-plugin install discovery-ec2

COPY elasticsearch-aws.sh /elasticsearch-aws.sh
CMD ["/elasticsearch-aws.sh"]
