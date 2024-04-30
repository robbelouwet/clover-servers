FROM --platform=linux/amd64 ubuntu:latest

EXPOSE 25565
EXPOSE 8765

COPY ./forge/base/entrypoint.sh /entrypoint.sh
COPY ./forge/base/template-files /template-files
COPY ./wss-cert/certificate.pem /certificate.pem
COPY ./wss-cert/certificate.key /certificate.key

COPY ./process_stdio_wrapper.py /process_stdio_wrapper.py
COPY ./requirements.txt /requirements.txt

RUN apt-get update && apt-get install -y wget git openjdk-17-jre python3 python3-pip bc

RUN pip3 install -r /requirements.txt

RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 &&\
    chmod a+x /usr/local/bin/yq

RUN wget -P / 

CMD [ "/bin/bash", "-c", "/entrypoint.sh" ]