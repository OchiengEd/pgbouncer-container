FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
ARG VERSION=1.17.0
ARG PGBOUNCER_VER=pgbouncer-$VERSION.tar.gz
ENV USER_ID=1001
ADD LICENSE /licenses/apache2
LABEL name=pgbouncer \
      vendor='Unknown' \
      version=$VERSION \
      release='stable' \
      description='PgBouncer is a connection pooler for PostgreSQL' \
      summary='PgBouncer pools connections to effectively improve performance of applications'

RUN microdnf install -y make openssl-devel libevent libevent-devel pkgconfig automake autoconf gcc curl glibc-devel tar gzip && \

curl -sLo /tmp/${PGBOUNCER_VER} https://pgbouncer.github.io/downloads/files/$VERSION/${PGBOUNCER_VER} && \

tar xzvf /tmp/${PGBOUNCER_VER} -C /opt && \

mkdir /etc/pgbouncer && \

cd /opt/pgbouncer-$VERSION && ./configure && \

make && make install && \

cp etc/pgbouncer.ini /etc/pgbouncer && \

cd / && rm -rf /opt/pgbouncer-$VERSION

WORKDIR /
ADD entrypoint.sh .

VOLUME ["/pgconf"]
EXPOSE 5432
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/local/bin/pgbouncer", "/pgconf/pgbouncer.ini"]
