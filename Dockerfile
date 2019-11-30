FROM alpine:3.10

# init some stuff
# also get the latest mumble version from github api
RUN apk --no-cache add murmur \
    && mkdir -p /opt/murmur/ \
    && cp -f /etc/murmur.ini /opt/murmur/docker-murmur.ini \
    && chmod -R 755 /opt/murmur \
    && chown -R murmur:murmur /opt/murmur

EXPOSE 64738/udp 64738/tcp

CMD ["/usr/bin/murmurd", "-fg", "-v", "-ini", "/opt/murmur/docker-murmur.ini"]

COPY ./bin /usr/local/bin

VOLUME ["/opt/murmur/"]