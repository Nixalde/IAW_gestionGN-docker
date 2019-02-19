FROM debian:latest

RUN apt update; \
    apt upgrade; \
    apt install -y git php7.0 php7.0-mysql libapache2-mod-wsgi-py3 python3-pip apache2 python3 python3-mysqldb

RUN cd /var/www; \
    git clone https://github.com/jd-iesgn/iaw_gestionGN.git; \
    pip3 install -r iaw_gestionGN/requirements.txt; \
    pip3 install mysql-connector-python

COPY ./settings.py /var/www/iaw_gestionGN/gestion/
COPY ./iawgestion-docker.conf /etc/apache/sites-enabled/

RUN python3 /var/www/iaw_gestionGN/manage.py collectstatic; \
    python3 /var/www&iaw_gestionGN/manage.py collecttemplates; \
    python3 /var/www/iaw_gestionGN/manage.py migrate; \
    python3 /var/www/iaw_gestionGN/manage.py loaddata /var/www/iaw_gestionGN/datos.json

CMD apache2ctl -D FOREGROUND
