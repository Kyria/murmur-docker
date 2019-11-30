FROM alpine:3.10

# init some stuff
# also get the latest mumble version from github api
RUN addgroup -g 1001 murmur \
    && adduser -G murmur -u 1001 -HD -s /bin/sh murmur \
    && apk --no-cache add murmur \
    && mkdir -p /opt/murmur/ \
    && cp -f /etc/murmur.ini /opt/murmur/docker-murmur.ini \
    && chmod -R 755 /opt/murmur \
    && chown -R murmur:murmur /opt/murmur

USER murmur:murmur
EXPOSE 64738/udp 64738/tcp

CMD ["/usr/bin/murmurd", "-fg", "-v", "-ini", "/opt/murmur/docker-murmur.ini"]

COPY ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

VOLUME ["/opt/murmur/"]