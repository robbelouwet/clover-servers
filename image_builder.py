import json
import os
import sys

test = "11"

def build_java_base():
    fs = open('java-base/version_config.json', 'r')
    configs = json.load(fs)
    for config in configs:
        if config["jvm_version"] != test: continue
        command = (f'docker build '
            f'-f java-base/Dockerfile '
            f'-t robbelouwet/java-base:{config["jvm_version"]}-{config["python_version"]} '
            f'--build-arg="JVM_VERSION={config["jvm_version"]}" '
            f'--build-arg="PYTHON_VERSION={config["python_version"]}" '
            f'.')
        print(command)
        os.system(command)
        


def build_forge():
    fs = open('forge/base/version_config.json', 'r')
    configs = json.load(fs)

    for config in configs:
        if config["minecraft_version"] != "1.16.5": continue
        command = (f'docker build '
                   f'-f forge/base/Dockerfile '
                   f'-t robbelouwet/forge-dedicated:{config["minecraft_version"]}-{config["forge_version"]} '
                   f'--build-arg="DOWNLOAD_LINK={config["download_link"]}" '
                   f'--build-arg="JAVA_BASE={config["jvm_version"]}" '
                   f'.')
        print(command)
        os.system(command)

    command = (f'docker build '
        f'-f forge/pixelmon/Dockerfile '
        f'-t robbelouwet/pixelmon:1.16.5 '
        f'--build-arg="ARG_MOD_VERSION=9.1.11" '
        f'.')
    print(command)
    os.system(command)

    exit(0)


if __name__ == "__main__":
    build_java_base()
    build_forge()