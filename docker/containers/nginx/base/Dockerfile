FROM nginx:1.15

WORKDIR /var/www/app

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configurations
COPY ./docker/containers/nginx/default.conf /etc/nginx/conf.d/default.conf
