FROM ubuntu:latest

EXPOSE 25565

COPY ./entrypoint.sh /entrypoint.sh

VOLUME /data

RUN apt-get update && apt-get install -y wget git openjdk-17-jre

RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 &&\
    chmod a+x /usr/local/bin/yq

RUN wget -P / https://api.papermc.io/v2/projects/paper/versions/1.20.2/builds/297/downloads/paper-mojmap-1.20.2-297.jar

CMD [ "/bin/bash", "-c", "/entrypoint.sh" ]