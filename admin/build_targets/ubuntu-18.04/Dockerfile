FROM ubuntu:18.04

RUN apt-get update && \
    apt-get dist-upgrade -y

RUN apt-get install --no-install-recommends -y build-essential \
                                               git \
                                               libenchant-dev \
                                               libffi-dev \
                                               libssl-dev \
                                               lintian \
                                               python \
                                               python2.7-dev \
                                               python-pip \
                                               rsync \
                                               ruby \
                                               ruby-dev \
                                               rubygems-integration

RUN gem install fpm -v 1.9.3

# python /tmp/get-pip.py pip==8.1.2 setuptools==23.0.0
# /bin/sh -c #(nop) MAINTAINER ClusterHQ <contact@clusterhq.com>
CMD ["/bin/bash"]

COPY requirements/*.txt /requirements/
RUN ["pip", "install", "--upgrade", "pip==10.0.1", "setuptools==39.1.0"]
RUN ["pip", "install",\
     "--requirement", "/requirements/all.txt",\
     "--constraint", "/requirements/constraints.txt"]
VOLUME /flocker
ENTRYPOINT ["/flocker/admin/build-package-entrypoint", "--destination-path=/output"]
