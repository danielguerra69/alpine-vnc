FROM alpine:edge
MAINTAINER Daniel Guerra
ADD /apk /apk
RUN cp /apk/.abuild/-57cfc5fa.rsa.pub /etc/apk/keys
RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk --update add /apk/ossp-uuid-1.6.2-r0.apk
RUN apk add /apk/ossp-uuid-dev-1.6.2-r0.apk
RUN apk add /apk/x11vnc-0.9.13-r0.apk
RUN apk add xvfb openbox xterm@testing supervisor sudo \
&& addgroup alpine \
&& adduser  -G alpine -s /bin/sh -D alpine \
&& echo "alpine:alpine" | /usr/sbin/chpasswd \
&& echo "alpine    ALL=(ALL) ALL" >> /etc/sudoers \
&& rm -rf /apk /tmp/* /var/cache/apk/*
ADD etc /etc
EXPOSE 5900
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
