FROM mariadb:10.2

ENV MYSQL_ROOT_PASSWORD test
ENV MYSQL_DATABASE test
ENV MYSQL_USER test
ENV MYSQL_PASSWORD test
ENV MYSQL_ROOT_HOST "%"

COPY ./docker/containers/mariadb/local.cnf /etc/mysql/conf.d/local.cnf
RUN chmod 644 /etc/mysql/conf.d/local.cnf
