FROM 713han/ubuntu_nginx:latest

MAINTAINER 713han@gmail.com

ARG DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get update && \
  apt-get install -y software-properties-common && \
  LC_ALL=C.UTF-8 add-apt-repository -y -u ppa:ondrej/php && \
  apt-get update && \
  apt-get install -y php-pear php7.2-dev zip unzip curl wget telnet vim bzip2 locales graphicsmagick && \
  apt-get install -y php7.2-fpm php7.2-cli php7.2-mysql php7.2-gd php7.2-json php7.2-mbstring php7.2-opcache php7.2-readline php7.2-xml php7.2-zip php7.2-curl php-memcached php-gmagick php-redis && \
  sed -i -E "s|^([;]?)cgi.fix_pathinfo.*|cgi.fix_pathinfo = 0|" /etc/php/7.2/fpm/php.ini && \
  sed -i -E "s|^([;]?)mbstring.internal_encoding.*|mbstring.internal_encoding = UTF-8|" /etc/php/7.2/fpm/php.ini && \
  sed -i -E "s|^([;]?) max_input_vars.*|max_input_vars = 5000|" /etc/php/7.2/fpm/php.ini && \
  sed -i -E "s|^([;]?)date.timezone.*|date.timezone = \"Asia/Taipei\"|" /etc/php/7.2/fpm/php.ini && \
  sed -i -E "s|^([;]?)pm.max_children.*|pm.max_children = 20|" /etc/php/7.2/fpm/pool.d/www.conf && \
  sed -i -E "s|^([;]?)pm.start_servers.*|pm.start_servers = 5|" /etc/php/7.2/fpm/pool.d/www.conf && \
  sed -i -E "s|^([;]?)pm.min_spare_servers.*|pm.min_spare_servers = 5|" /etc/php/7.2/fpm/pool.d/www.conf && \
  sed -i -E "s|^([;]?)pm.max_spare_servers.*|pm.max_spare_servers = 15|" /etc/php/7.2/fpm/pool.d/www.conf && \
  sed -i -E "s|^([;]?)pm.status_path.*|pm.status_path = /php_fpm_www_status|" /etc/php/7.2/fpm/pool.d/www.conf && \
  sed -i -E "s|^([;]?)slowlog.*|slowlog = /var/log/php-fpm_\$pool_slow.log|" /etc/php/7.2/fpm/pool.d/www.conf && \
  sed -i -E "s|^([;]?)request_slowlog_timeout.*|request_slowlog_timeout = 5|" /etc/php/7.2/fpm/pool.d/www.conf && \
  mkdir --mode 777 /var/run/php && \
  mkdir -p /run /var/lib/nginx /var/lib/php && \
  chmod -R 777 /run /var/lib/nginx /var/lib/php /etc/php/7.2/fpm/php.ini

EXPOSE 80 443

CMD \
  service php7.2-fpm start && \
  service nginx start && \
  tail -f /var/log/php7.2-fpm.log