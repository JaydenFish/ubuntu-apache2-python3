FROM ubuntu:18.04
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y vim python3.6 python3-pip apache2 libapache2-mod-wsgi-py3 cron
RUN rm -f /usr/bin/pip & ln -s /usr/bin/pip3 /usr/bin/pip
RUN mkdir -p /root/.pip/
RUN echo -e "[global]\nindex-url = https://pypi.tuna.tsinghua.edu.cn/simple" > /root/.pip/pip.conf
RUN rm -f /usr/bin/python & ln -s /usr/bin/python3 /usr/bin/python
RUN echo "ServerName localhost:80" >> /etc/apache2/apache2.conf
RUN ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load
RUN echo -e "<IfModule mod_rewrite.c>\n        RewriteEngine on\n        RewriteCond %{HTTP:Authorization} ^(.*)\n        RewriteRule ^(.*) - [E=HTTP_AUTHORIZATION:%1]\n        SetEnvIf Authorization \"(.*)\" HTTP_AUTHORIZATION=\$1\n</IfModule>" > /etc/apache2/mods-enabled/rewrite.conf
RUN rm -f /etc/apache2/sites-enabled/000-default.conf
CMD ["apachectl", "-D", "FOREGROUND"]