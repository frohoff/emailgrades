FROM ubuntu:latest

WORKDIR /app

ENV DEBIAN_FRONTEND noninteractive 

RUN apt-get update && apt-get upgrade -y && apt-get install -y curl nodejs npm libfontconfig cron rsyslog strace
RUN ln -s `which nodejs` /usr/bin/node
RUN npm install -g phantomjs-prebuilt casperjs

ADD crontab /etc/cron.d/emailgrades

ADD * /app/

RUN chmod 0755 /etc/cron.d/emailgrades /app/emailgrades.sh
 
#RUN touch /var/log/cron.log

#RUN echo "export USERNAME=$USERNAME" >> /app/.env
#RUN echo "export PASSWORD=$PASSWORD" >> /app/.env
#RUN echo "export FROM=$FROM" >> /app/.env
#RUN echo "export TO=$TO" >> /app/.env

#CMD /app/emailgrades.sh 

#CMD env | sed 's/^\(.*\)\=\(.*\)$/export \1\="\2"/g' > /app/.env && strace -f cron -f -L15

CMD env | sed 's/^\(.*\)\=\(.*\)$/export \1\="\2"/g' > /app/.env && cron -f -L15