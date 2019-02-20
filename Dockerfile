FROM debian:latest

RUN apt update; \
    apt upgrade; \
    apt install -y git mariadb-client libapache2-mod-wsgi-py3 python3-pip apache2 python3 python3-mysqldb

RUN git clone https://github.com/Nixalde/iaw_gestionGN.git; \
    mv ./iaw_gestionGN /var/www/; \
    pip3 install -r /var/www/iaw_gestionGN/requirements.txt; \
    pip3 install mysql-connector-python

COPY ./settings.py /var/www/iaw_gestionGN/gestion/
COPY ./iawgestion-docker.conf /etc/apache2/sites-enabled/

CMD python3 /var/www/iaw_gestionGN/manage.py migrate; \
    python3 /var/www/iaw_gestionGN/manage.py loaddata /var/www/iaw_gestionGN/datos.json; \
    apache2ctl -D FOREGROUND
