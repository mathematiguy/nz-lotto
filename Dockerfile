FROM continuumio/anaconda3

COPY requirements.txt /root/requirements.txt
RUN while read requirement; do conda install --yes $requirement; done < /root/requirements.txt

RUN conda install -c conda-forge scrapy 