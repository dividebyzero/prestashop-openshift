FROM prestashop/prestashop:1.7

#use port 8080 (non-privileged) as default
ARG ARG_APACHE_LISTEN_PORT=8080
ENV APACHE_LISTEN_PORT=${ARG_APACHE_LISTEN_PORT}
RUN sed -s -i -e "s/80/${APACHE_LISTEN_PORT}/" /etc/apache2/ports.conf /etc/apache2/sites-available/*.conf

#make debug life easier
RUN apt-get update && apt-get install nano

#fix permissions for openshift..
RUN usermod -G 0 www-data
RUN chgrp -R 0 /var/www && chmod -R g+rwx /var/www
RUN chgrp -R 0 /var/cache && chmod -R g+rwx /var/cache

#extend timeouts for install script
COPY ./custom.conf /etc/apache2/conf-enabled
RUN  sed -i 's/max_execution_time = 30/max_execution_time = 1200/' /usr/local/etc/php/php.ini
RUN  sed -i 's/max_input_time = 60/max_input_time = 1200/' /usr/local/etc/php/php.ini

USER www-data
EXPOSE ${APACHE_LISTEN_PORT}
