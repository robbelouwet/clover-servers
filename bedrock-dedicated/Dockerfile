FROM --platform=linux/amd64 ubuntu:latest

# EXPOSE 19132/tcp

# Bedrock uses UDP! Currently not supported in azure container apps
EXPOSE 19132/udp

EXPOSE 8765/tcp
# EXPOSE 8765/udp

COPY ./entrypoint.sh /entrypoint.sh
COPY ./template-files /template-files

COPY ./process_stdio_wrapper.py /process_stdio_wrapper.py
COPY ./requirements.txt /requirements.txt

RUN apt-get update && apt-get install -y wget unzip git nfs-common python3 python3-pip libcurl4-openssl-dev

RUN pip3 install -r /requirements.txt

RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 &&\
    chmod a+x /usr/local/bin/yq

RUN wget -P / https://minecraft.azureedge.net/bin-linux/bedrock-server-1.20.71.01.zip

RUN mkdir /bootstrap-server-files && unzip -n /bedrock-server-1.20.71.01.zip -d /bootstrap-server-files

CMD [ "/bin/bash", "-c", "/entrypoint.sh" ]