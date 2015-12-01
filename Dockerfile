FROM centos:7

ADD yum.conf /etc/yum.conf

RUN \
  yum -y install wget bzip2 && \
  curl -O -L -k https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2 && \
  bunzip2 phantomjs-1.9.8-linux-x86_64.tar.bz2 && tar xf phantomjs-1.9.8-linux-x86_64.tar 

RUN \
  yum install -y epel-release && \
  yum install -y git python-pip python-devel libpng-devel libjpeg-devel gcc gcc-c++ make libffi-devel openssl-devel && \
  pip install --trusted-host pypi.python.org requests[security] && \
  pip install --trusted-host pypi.python.org Django==1.8.6 && \
  pip install --trusted-host pypi.python.org Pillow pika gunicorn

RUN \
  yum -y install fontconfig libfontenc fontconfig-devel \
  libXfont ghostscript-fonts xorg-x11-font-utils urw-fonts

COPY webrender /django-phantomjs

COPY settings.py /django-phantomjs/phantomjs/

WORKDIR django-phantomjs

RUN \
  python manage.py migrate

EXPOSE 8000

CMD gunicorn -c gunicorn.ini wsgi:application

# Note on Ubuntu 14.04 font packages include:
# xfonts-base ttf-mscorefonts-installer fonts-arphic-bkai00mp fonts-arphic-bsmi00lp fonts-arphic-gbsn00lp fonts-arphic-gkai00mp fonts-arphic-ukai fonts-farsiweb fonts-nafees fonts-sil-abyssinica fonts-sil-ezra fonts-sil-padauk fonts-unfonts-extra fonts-unfonts-core ttf-indic-fonts fonts-thai-tlwg fonts-lklug-sinhala