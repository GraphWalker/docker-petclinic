FROM ubuntu:latest

RUN apt-get update && apt-get install -y vim openjdk-8-jdk maven git wget bzip2 firefox && apt-get remove firefox -y && rm -rf /var/cache/apt/

RUN cd /usr/local && wget http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/47.0.1/linux-x86_64/en-US/firefox-47.0.1.tar.bz2 && ls -l && tar xvjf firefox-47.0.1.tar.bz2 && ln -s /usr/local/firefox/firefox /usr/bin/firefox


# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
mkdir -p /home/developer && \
mkdir -p /etc/sudoers.d && \
echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
echo "developer:x:${uid}:" >> /etc/group && \
echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
chmod 0440 /etc/sudoers.d/developer && \
chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer

RUN cd /home/developer && git clone https://github.com/GraphWalker/graphwalker-example && cd graphwalker-example/java-petclinic && mvn graphwalker:generate-sources package 
RUN cd /home/developer && git clone https://github.com/SpringSource/spring-petclinic.git && cd spring-petclinic && git reset --hard 482eeb1c217789b5d772f5c15c3ab7aa89caf279 
RUN cd /home/developer && echo "#!/bin/bash" > start.sh && echo "cd /home/developer/spring-petclinic && mvn tomcat7:run > spring.log 2>&1 &" >> start.sh && echo "sleep 10" >> start.sh
RUN chmod +x /home/developer/start.sh

CMD bash -C '/home/developer/start.sh' && cd /home/developer/graphwalker-example/java-petclinic && echo "Run following command:" && echo 'mvn exec:java -Dexec.mainClass="com.company.runners.GraphStreamApplication"' && bash
