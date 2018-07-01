FROM ubuntu:16.04

# COPY .docker/sources.list /etc/apt/sources.list
COPY .docker/texlive.profile .docker/packages.txt /tmp/

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && \
    apt-get install -qq --no-install-recommends apt-utils && \
    apt-get upgrade -qq && \
    apt-get install -qq --no-install-recommends \
	    wget ca-certificates perl fontconfig make zip && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/*

# set up packages
# RUN TL_MIRROR=https://linux.xidian.edu.cn/mirrors/CTAN/systems/texlive/tlnet && \
RUN TL_MIRROR=http://mirror.ctan.org/systems/texlive/tlnet && \
    wget --quiet ${TL_MIRROR}/install-tl-unx.tar.gz && \
    tar -xzf install-tl-unx.tar.gz && \
    install-tl-20*/install-tl -repository ${TL_MIRROR} \
                              -profile=/tmp/texlive.profile && \
    rm -r install-tl-unx.tar.gz install-tl-20*

RUN /usr/local/texlive/bin/x86_64-linux/tlmgr install $(cat /tmp/packages.txt)
RUN /usr/local/texlive/bin/x86_64-linux/tlmgr path add
    
