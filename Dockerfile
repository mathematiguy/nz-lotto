FROM rocker/tidyverse

# Use New Zealand mirrors
RUN sed -i 's/archive/nz.archive/' /etc/apt/sources.list

RUN apt update && apt install libxt6

# Set timezone to Auckland
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y locales tzdata
RUN locale-gen en_NZ.UTF-8
RUN dpkg-reconfigure locales
RUN echo "Pacific/Auckland" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata
ENV LANG en_NZ.UTF-8
ENV LANGUAGE en_NZ:en

RUN apt update && apt install -y python3 python3-pip
COPY requirements.txt /root/requirements.txt
RUN pip3 install -r /root/requirements.txt

RUN Rscript -e 'install.packages("here")'
RUN Rscript -e 'install.packages("furrr")'
RUN Rscript -e 'install.packages("jsonlite")'
RUN Rscript -e 'install.packages("rstan", Ncpus=parallel::detectCores()-1)'
RUN Rscript -e 'install.packages("brms", Ncpus=parallel::detectCores()-1)'

