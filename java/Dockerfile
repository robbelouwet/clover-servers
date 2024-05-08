# Default base image for all java-based servers (paper, forge, spigot, ...)

ARG ARCH=linux/arm64

FROM --platform=${ARCH} ubuntu:latest

ARG JAVA_VERSION
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y openjdk-${JAVA_VERSION}-jre

RUN apt update && apt install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get install -y git python3.9 python3-pip