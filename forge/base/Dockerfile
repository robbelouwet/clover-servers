FROM  --platform=linux/amd64 robbelouwet/java-base:11-3.9 as builder
ARG DOWNLOAD_LINK
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y wget
RUN wget -P / ${DOWNLOAD_LINK}
RUN mkdir /files && touch /files/eula.txt && echo "eula=true" > /files/eula.txt
RUN java -jar /*.jar --installServer /files


FROM --platform=linux/amd64 robbelouwet/java-base:11-3.9


EXPOSE 25565
EXPOSE 8765

COPY ./forge/base/entrypoint.sh /entrypoint.sh
COPY ./forge/base/template-files /template-files
COPY ./wss-cert/certificate.pem /certificate.pem
COPY ./wss-cert/certificate.key /certificate.key

COPY ./process_stdio_wrapper.py /process_stdio_wrapper.py
COPY ./requirements.txt /requirements.txt

RUN apt update && apt install -y wget bc
RUN pip3 install --break-system-packages -r /requirements.txt
RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
RUN chmod a+x /usr/local/bin/yq

COPY --from=builder /files /template-files

CMD [ "/bin/bash", "-c", "/entrypoint.sh" ]