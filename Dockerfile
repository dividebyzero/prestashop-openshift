FROM prestashop/prestashop:1.7
ARG ARG_APACHE_LISTEN_PORT=8080
ENV APACHE_LISTEN_PORT=${ARG_APACHE_LISTEN_PORT}
RUN sed -s -i -e "s/80/${APACHE_LISTEN_PORT}/" /etc/apache2/ports.conf /etc/apache2/sites-available/*.conf

RUN apt-get update && apt-get install nano
RUN chmod -R g+rwx /var/www
RUN chmod -R g+rwx /var/cache

COPY ./custom.conf /etc/apache2/conf-enabled

EXPOSE ${APACHE_LISTEN_PORT}
