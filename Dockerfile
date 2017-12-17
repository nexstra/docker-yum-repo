FROM amazonlinux
MAINTAINER David Lee <dlee@nexstra.com>
RUN yum clean all && yum -y install epel-release && \
    yum-config-manager --enable epel && \
    yum -y update
RUN yum -y install createrepo inotify-tools findutils util-linux

RUN mkdir /repo
ADD startup.sh /
RUN chmod 755 /startup.sh
VOLUME /repo

ENTRYPOINT ["/startup.sh"]




