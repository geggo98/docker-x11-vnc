# Dockerfile for containerizing a graphical X11 applications. 
# 
# X11 applications are exposed via VNC on port 5900
#
# The VNC port is unprotected. To protect it, one can
# use a separete ssh jump host, e.g. 
# https://registry.hub.docker.com/u/geggo98/ssh-vpn-jump-host/
# 
# Author: stefan@schwetschke.de
# Date: 2014-11-06


FROM ubuntu:14.04
MAINTAINER Stefan Schwetschke "stefan@schwetschke.de"

ENV REFRESHED_APT_AT 2015-01-15

RUN apt-get update -y
RUN apt-get upgrade -y

# Set locale to UTF-8 to fix the locale warnings
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || :

# Set DEBIAN_FRONTEND to noninteractive, so dpkg will not wait for user inputs
ENV DEBIAN_FRONTEND noninteractive

# Installing the environment required: xserver, xdm, flux box, roc-filer and ssh
RUN apt-get install -y lxde-core lxterminal xvfb x11vnc sudo


# Fix problems with Upstart and DBus inside a docker container.
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl

# Install some basic packages
RUN apt-get install -y firefox xterm

# Copy the files into the container
ADD . /x11-src
RUN chmod -R a=rX /x11-src

# Clean up apt-get
RUN apt-get clean

# Local user, may be overwritten by dependent build
ENV X11_USER xclient

# Resolution and color depth of simulated display
ENV RESOLUTION 1280x1024x16

WORKDIR /home/${X11_USER} 
VOLUME /home/${X11_USER}
EXPOSE 5900

# Start x11vnc
ENTRYPOINT ["/bin/bash", "/x11-src/startup.sh"]
CMD ["/usr/bin/lxterminal"]
