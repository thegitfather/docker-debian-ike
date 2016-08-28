FROM debian:jessie
MAINTAINER thegitfather <baranowski@joinpoint.org>

RUN apt-get update && apt-get install -y \
    ike \
    net-tools \
    socat \
    psmisc

COPY sites /root/.ike/sites
COPY startup.sh /root

ENTRYPOINT ["/root/startup.sh"]
