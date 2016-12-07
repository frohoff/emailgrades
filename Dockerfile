FROM ubuntu:latest

WORKDIR /app

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get install -y curl nodejs npm libfontconfig cron rsyslog strace
RUN ln -s `which nodejs` /usr/bin/node
RUN npm install -g phantomjs-prebuilt casperjs

ADD crontab /etc/cron.d/emailgrades

ADD emailgrades.sh /app/
ADD grades.js /app/

RUN chmod 0755 /etc/cron.d/emailgrades /app/emailgrades.sh

#CMD /app/emailgrades.sh

CMD env | sed 's/^\(.*\)\=\(.*\)$/export \1\="\2"/g' > /app/.env && cron -f -L15