FROM ubuntu
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get -q update
RUN apt-get -qy install wget nginx
RUN apt-get -qy install software-properties-common zip unzip
RUN apt-get -qy install python-software-properties python gcc g++ make
RUN add-apt-repository ppa:chris-lea/node.js
RUN apt-get -q update
RUN apt-get -qy install -y nodejs
RUN wget -q --no-check-certificate https://ghost.org/zip/ghost-0.3.3.zip -O /tmp/ghost.zip
RUN unzip -ou /tmp/ghost.zip -d /ghost
RUN sed -i -e 's/127.0.0.1/0.0.0.0/g' /ghost/config.example.js
RUN cd /ghost && npm install --production
EXPOSE 2368
ADD init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh
ADD run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh
CMD ["/usr/local/bin/run.sh"]