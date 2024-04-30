FROM --platform=linux/amd64 robbelouwet/forge-dedicated:1.16.5-36.2.42
ARG ARG_MOD_VERSION
ARG DEBIAN_FRONTEND=noninteractive
LABEL MOD_VERSION=${ARG_MOD_VERSION}

RUN wget -P /template-files/mods https://download.nodecdn.net/containers/reforged/universal/release/Pixelmon-1.16.5-9.1.11-universal.jar
