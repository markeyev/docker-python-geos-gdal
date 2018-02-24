FROM python:2.7

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update -y && \
    apt-get -qq install --no-install-recommends -y postgresql-client && \
    apt-get clean all

# use "build --build-arg processor_count=$(getconf _NPROCESSORS_ONLN)"
ARG processor_count=1
ENV PROCESSOR_COUNT $processor_count

#### Install GEOS ####
ENV GEOS http://download.osgeo.org/geos/geos-3.6.2.tar.bz2

WORKDIR /install-postgis
WORKDIR /install-postgis/geos

ADD $GEOS /install-postgis/geos.tar.bz2

RUN tar xf /install-postgis/geos.tar.bz2 -C /install-postgis/geos --strip-components=1
RUN ./configure && make -j $PROCESSOR_COUNT && make install
RUN ldconfig

WORKDIR /install-postgis

RUN test -x geos

#### Install GDAL ####

ENV GDAL http://download.osgeo.org/gdal/1.11.5/gdal-1.11.5.tar.gz

WORKDIR /install-postgis/gdal

ADD $GDAL /install-postgis/gdal.tar.bz2

RUN tar xf /install-postgis/gdal.tar.bz2 -C /install-postgis/gdal --strip-components=1
RUN ./configure && make -j $PROCESSOR_COUNT && make install
RUN ldconfig
