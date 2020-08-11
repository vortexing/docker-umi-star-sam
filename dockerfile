# build as vortexing/samtools:1.10
FROM ubuntu:18.04

RUN apt-get update && apt-get -y upgrade && \
	apt-get install -y build-essential wget \
		libncurses5-dev zlib1g-dev libbz2-dev liblzma-dev libcurl3-dev python3-pip && \
	apt-get clean && apt-get purge && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget https://github.com/samtools/samtools/releases/download/1.10/samtools-1.10.tar.bz2 && \
	tar jxf samtools-1.10.tar.bz2 && \
	rm samtools-1.10.tar.bz2 && \
	cd samtools-1.10 && \
	./configure --prefix $(pwd) && \
	make
ENV PATH=${PATH}:/samtools-1.10

# Add UMI tools

ARG PACKAGE_VERSION=1.0.1
ARG DEBIAN_FRONTEND=noninteractive

RUN pip3 install --upgrade pip && \
    pip3 install umi_tools==$PACKAGE_VERSION

RUN ln -s /usr/bin/python3 /usr/local/bin/python

## Add STAR

RUN wget https://github.com/alexdobin/STAR/archive/2.7.1a.tar.gz && \
	tar zxf 2.7.1a.tar.gz

WORKDIR /STAR-2.7.1a/source

RUN make STAR

RUN cp STAR /usr/local/bin/

WORKDIR /

RUN rm -rf 2.7.1a.tar.gz STAR-2.7.1a