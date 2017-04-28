FROM ubuntu:16.04

MAINTAINER Srdjan Grubor <sgnn7@sgnn7.org>

# You can't have aufs on aufs so this is mandatory to have bind-mounted
# on some systems
# VOLUME /var/lib/docker

# Add Docker repo key
# XXX: Done early to reuse cache as much as possible
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get install -y apt-transport-https

RUN echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list

RUN apt-get update && \
    apt-get install -y docker-engine \
                       libffi-dev \
                       libssl-dev \
                       lsb-release \
                       python \
                       python-pip \
                       sudo \
                       virtualenv && \
    apt-get clean

# Get tini to handle reaping and signal processing
ENV TINI_VERSION v0.14.0

ADD https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini /usr/local/bin/tini
ADD https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini.asc /usr/local/bin/tini.asc

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 6380DC428747F6C393FEACA59A84159D7001A4E5 && \
    gpg --verify /usr/local/bin/tini.asc && \
    rm -r /usr/local/bin/tini.asc

RUN chmod +x /usr/local/bin/tini

# We want a limited user even though we technically are using a privileged container
RUN groupadd -r -g 910 builder
RUN useradd -m -r -u 910 -g 910 builder

# Builder needs to be in docker group to avoid requirements for sudo
RUN usermod -a -G docker builder

RUN mkdir -p /opt/flocker && \
    chown builder:builder /opt/flocker

# Added last to avoid cache busting
COPY build_flocker.sh build.sh dind_wrapper.sh \
     /usr/local/bin/

RUN chmod +x /usr/local/bin/build_flocker.sh \
             /usr/local/bin/build.sh \
             /usr/local/bin/dind_wrapper.sh

ENTRYPOINT ["/usr/local/bin/tini", "-g", "--"]
CMD ["/usr/local/bin/build.sh"]
