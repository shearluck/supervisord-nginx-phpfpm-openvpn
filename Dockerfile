FROM ubuntu:14.04
MAINTAINER njarencio@gmail.com

RUN apt-get update && apt-get install -y curl openvpn supervisor
RUN apt-get install -y nginx php5-fpm php5-curl
RUN mkdir -p /var/log/supervisor

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD nginx-default /etc/nginx/sites-available/default

ADD google.php /usr/share/nginx/html/google.php
ADD ip.php /usr/share/nginx/html/ip.php
ADD hma-vpn /usr/hma-vpn
ADD password.conf /usr/password.conf

# set permission to only readable by you
RUN chmod 0400 /usr/password.conf

# nginx config
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# php-fpm config
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
#RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini
#RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf

EXPOSE 80

CMD ["/usr/bin/supervisord"]
