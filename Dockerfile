FROM rocker/shiny:3.6.0
LABEL maintainer="Ben Artin <ben@artins.org>"

### Setup apt
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y -qq

### Setup misc packages needed to build the image
ARG DOCKER_BUILD_APT_DEPENDENCIES="tzdata locales"
RUN apt-get update -y -qq && \
  apt-get install -y -qq --no-install-recommends ${BASE_APT_DEPENDENCIES} && \
  apt-get autoremove -y && \
  apt-get clean

# Configure apt packages
RUN echo tzdata tzdata/Areas select America >> /tmp/debconf.txt
RUN echo tzdata tzdata/Zones/America select New_York >> /tmp/debconf.txt
RUN debconf-set-selections /tmp/debconf.txt
RUN rm /etc/timezone
RUN rm /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata
RUN update-locale --reset LANG=en_US.utf8 LANGUAGE=en_US LC_ALL=en_US.utf8 LC_CTYPE=en_US.utf8

### Install required R packages. 
ARG DEVTOOLS_BUILD_APT_DEPENDENCIES="libssl-dev gnutls-dev libcurl4-gnutls-dev libgit2-dev libssh2-1-dev"
ARG DEVTOOLS_APT_DEPENDENCIES="libgnutls-openssl27 libcurl3-gnutls libgit2-24 libssh2-1"
RUN apt-get update -y -qq && \
  apt-get install -y -qq --no-install-recommends ${DEVTOOLS_BUILD_APT_DEPENDENCIES} ${DEVTOOLS_APT_DEPENDENCIES} && \
  install2.r devtools && \
  apt-mark auto ${DEVTOOLS_BUILD_APT_DEPENDENCIES} && \
  apt-get autoremove -y && \
  apt-get clean

WORKDIR /usr/src
COPY . .

RUN Rscript -e 'devtools::install_deps()'
