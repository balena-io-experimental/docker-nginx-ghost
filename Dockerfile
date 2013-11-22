FROM ubuntu:precise

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" >> /etc/apt/sources.list

RUN echo "deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu precise main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C7917B12

RUN apt-get update
RUN apt-get install -y wget nginx nginx-light zip unzip nodejs

RUN wget -q --no-check-certificate https://ghost.org/zip/ghost-0.3.3.zip -O /tmp/ghost.zip
RUN unzip -ou /tmp/ghost.zip -d /ghost

VOLUME ["/ghost"]
EXPOSE 80

ADD run.sh /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

CMD ["/usr/local/bin/run"]
