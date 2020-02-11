FROM rocker/tidyverse

# Use New Zealand mirrors
RUN sed -i 's/archive/nz.archive/' /etc/apt/sources.list

RUN apt update

# Set timezone to Auckland
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y locales tzdata
RUN locale-gen en_NZ.UTF-8
RUN dpkg-reconfigure locales
RUN echo "Pacific/Auckland" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata
ENV LANG en_NZ.UTF-8
ENV LANGUAGE en_NZ:en

RUN apt update && apt-get install -y openssh-server xorg-dev
RUN mkdir /var/run/sshd

ENV PASSWORD=root
RUN echo 'root:root' | chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt update && apt install -y python3 python3-pip
COPY requirements.txt /root/requirements.txt
RUN pip3 install -r /root/requirements.txt

RUN Rscript -e 'install.packages("here")'
RUN Rscript -e 'install.packages("furrr")'
RUN Rscript -e 'install.packages("jsonlite")'

EXPOSE 22
