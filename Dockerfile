FROM debian:12

ENV SPAMPD_RELAYHOST=smtp:10026
ENV SPAMPD_HOST=0.0.0.0:10025
ENV SPAMPD_SPAMASSASSIN_MODE=default
ENV SPAMPD_SPAMC_HOST=localhost
ENV SPAMPD_SPAMC_PORT=783
ENV SPAMPC_SPAMC_USERNAME=
ENV DEBIAN_FRONTEND noninteractive


RUN apt-get update && \
    apt-get install -y --no-install-recommends spampd \
    pyzor \
    razor \
    curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

VOLUME ["/var/cache/spampd"]

ENV DEBIAN_FRONTEND noninteractive

COPY misc/spampd.cfg /etc/default/spampd

COPY spampd.pl /usr/sbin/spampd

EXPOSE 10025

## Add startup script.
COPY misc/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 0755 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
