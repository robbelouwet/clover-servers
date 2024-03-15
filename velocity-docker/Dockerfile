FROM --platform=linux/amd64 ubuntu:latest

EXPOSE 25565/tcp
EXPOSE 25565/udp

COPY ./entrypoint.sh /entrypoint.sh
COPY ./velocity-proxy-3.3.0-SNAPSHOT-all.jar /velocity-proxy-3.3.0-SNAPSHOT-all.jar

RUN mkdir /template-files
COPY ./template-files/* /template-files

RUN apt-get update && apt-get install -y wget git openjdk-17-jre perl

RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 &&\
    chmod a+x /usr/local/bin/yq

# RUN wget -P / https://api.papermc.io/v2/projects/velocity/versions/3.2.0-SNAPSHOT/builds/294/downloads/velocity-3.2.0-SNAPSHOT-294.jar

CMD [ "/bin/bash", "-c", "/entrypoint.sh" ]