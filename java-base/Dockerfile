FROM --platform=linux/amd64 ubuntu:latest

ARG JVM_VERSION
ARG PYTHON_VERSION
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y openjdk-${JVM_VERSION}-jre

RUN apt update && apt install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get install -y git python${PYTHON_VERSION} python3-pip