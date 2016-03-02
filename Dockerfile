FROM alpine:latest

RUN apk --no-cache add groff less python py-pip
# below should install boto3 as well
RUN pip install awscli

# installs newest ansible, which requires some dev to be installed in order to compile
RUN apk --no-cache add gcc g++ autoconf make libffi-dev openssl-dev python-dev && \
  pip install ansible && \
  apk --no-cache del gcc g++ autoconf make libffi-dev openssl-dev python-dev
