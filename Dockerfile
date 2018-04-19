FROM danielguerra/alpine-sdk-build:3.7 as builder
MAINTAINER Daniel Guerra
RUN docker-entrypoint.sh
USER root
RUN apk add libxtst-dev xorg-server-dev
RUN mkdir -p /tmp/aports/unmaintained/x11vnc
COPY x11vnc/APKBUILD /tmp/aports/unmaintained/x11vnc/APKBUILD
RUN chown -R sdk:sdk /tmp/aports
USER sdk
RUN build unmaintained x11vnc


FROM alpine:3.7
MAINTAINER Daniel Guerra
COPY --from=builder /home/sdk/.abuild /tmp/.abuild
RUN find /tmp/.abuild -name "*.pub" -exec cp {} /etc/apk/keys \;
COPY --from=builder /home/sdk/packages/unmaintained/x86_64/x11vnc-0.9.13-r0.apk /tmp/x11vnc-0.9.13-r0.apk
RUN apk --no-cache --update add /tmp/x11vnc-0.9.13-r0.apk
RUN apk --no-cache add xvfb openbox xfce4-terminal supervisor sudo \
&& addgroup alpine \
&& adduser  -G alpine -s /bin/sh -D alpine \
&& echo "alpine:alpine" | /usr/sbin/chpasswd \
&& echo "alpine    ALL=(ALL) ALL" >> /etc/sudoers \
&& rm -rf /tmp/* /var/cache/apk/*
ADD etc /etc
WORKDIR /home/alpine
EXPOSE 5900
USER alpine
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
