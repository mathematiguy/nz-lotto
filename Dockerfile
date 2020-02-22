FROM dragonflyscience/dragonverse-18.04:latest

RUN apt update && apt install -y python3 python3-pip
COPY requirements.txt /root/requirements.txt
RUN pip3 install -r /root/requirements.txt

RUN Rscript -e 'install.packages("here")'
RUN Rscript -e 'install.packages("furrr")'
RUN Rscript -e 'install.packages("jsonlite")'
RUN Rscript -e 'install.packages("brms")'
RUN Rscript -e 'install.packages("MCMCpack")'
