FROM --platform=linux/amd64 ubuntu:latest

EXPOSE 19132/udp
EXPOSE 8765/tcp

COPY ./bedrock-dedicated/entrypoint.sh /entrypoint.sh
COPY ./bedrock-dedicated/template-files /template-files
COPY ./wss-cert/certificate.pem /certificate.pem
COPY ./wss-cert/certificate.key /certificate.key

COPY ./process_stdio_wrapper.py /process_stdio_wrapper.py
COPY ./bedrock-dedicated/requirements.txt /requirements.txt

RUN apt-get update && apt-get install -y wget unzip git python3 python3-pip libcurl4-openssl-dev openssl

RUN pip3 install -r /requirements.txt

RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 &&\
    chmod a+x /usr/local/bin/yq

RUN wget -P / https://minecraft.azureedge.net/bin-linux/bedrock-server-1.20.71.01.zip

RUN mkdir /bootstrap-server-files && unzip -n /bedrock-server-1.20.71.01.zip -d /bootstrap-server-files

CMD [ "/bin/bash", "-c", "/entrypoint.sh" ]