ARG ARCH=linux/arm64
ARG JAVA_VERSION

FROM --platform=${ARCH} java-base:${JAVA_VERSION}

EXPOSE 25565
EXPOSE 8765

COPY ./java/paper/entrypoint.sh /entrypoint.sh
COPY ./java/paper/template-files /template-files
COPY ./wss-cert/certificate.pem /certificate.pem
COPY ./wss-cert/certificate.key /certificate.key

COPY ./process_stdio_wrapper.py /process_stdio_wrapper.py
COPY ./requirements.txt /requirements.txt

RUN apt-get update && apt-get install -y wget git openjdk-17-jre python3 python3-pip bc

RUN pip3 install -r /requirements.txt

RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 &&\
    chmod a+x /usr/local/bin/yq

RUN wget -P / https://api.papermc.io/v2/projects/paper/versions/1.20.2/builds/297/downloads/paper-mojmap-1.20.2-297.jar

CMD [ "/bin/bash", "-c", "/entrypoint.sh" ]