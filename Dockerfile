FROM yamrd2/ubuntu-16_nginx:latest

MAINTAINER hanshuang@talk2yam.com

ARG DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get update && \
  apt-get install -y software-properties-common python-software-properties && \
  LC_ALL=C.UTF-8 add-apt-repository -y -u ppa:ondrej/php && \
  apt-get update && \
  apt-get install -y php-pear php7.1-dev zip unzip && \
  apt-get install -y php7.1-fpm php7.1-cli php7.1-mysql php7.1-gd php7.1-json php7.1-mbstring php7.1-mcrypt php7.1-opcache php7.1-readline php7.1-xml php7.1-zip php7.1-curl php-memcached php-gmagick php-redis && \
  sed -i -E "s|^([;]?)cgi.fix_pathinfo.*|cgi.fix_pathinfo = 0|" /etc/php/7.1/fpm/php.ini && \
  sed -i -E "s|^([;]?)mbstring.internal_encoding.*|mbstring.internal_encoding = UTF-8|" /etc/php/7.1/fpm/php.ini && \
  sed -i -E "s|^([;]?) max_input_vars.*|max_input_vars = 5000|" /etc/php/7.1/fpm/php.ini && \
  sed -i -E "s|^([;]?)pm.max_children.*|pm.max_children = 50|" /etc/php/7.1/fpm/pool.d/www.conf && \
  sed -i -E "s|^([;]?)pm.start_servers.*|pm.start_servers = 10|" /etc/php/7.1/fpm/pool.d/www.conf && \
  sed -i -E "s|^([;]?)pm.min_spare_servers.*|pm.min_spare_servers = 5|" /etc/php/7.1/fpm/pool.d/www.conf && \
  sed -i -E "s|^([;]?)pm.max_spare_servers.*|pm.max_spare_servers = 15|" /etc/php/7.1/fpm/pool.d/www.conf && \
  mkdir --mode 777 /var/run/php && \
  mkdir -p /run /var/lib/nginx /var/lib/php && \
  chmod -R 777 /run /var/lib/nginx /var/lib/php /etc/php/7.1/fpm/php.ini

EXPOSE 80 443

CMD ["service", "php7.1-fpm", "start"]
CMD ["nginx", "-g", "daemon off;"]
