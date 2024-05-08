import json
import os
import pathlib
import sys

if __name__ == "__main__":
    fs = open(f'{pathlib.Path(__file__).parent.resolve()}/version_config.json', 'r')
    configs = json.load(fs)

    override_version = None
    if len(sys.argv) > 1:
        if str(sys.argv[1]) not in map(lambda c: c["java_version"], configs):
            print(f"{sys.argv[1]} not an available java version.")
            exit(1)
        else:
            override_version = str(sys.argv[1])

    for config in configs:
        if override_version is not None and config["java_version"] != override_version: continue
        command = (f'docker build '
                   f'-f java/Dockerfile '
                   f'-t robbelouwet/java-base:{config["java_version"]} '
                   f'--build-arg="ARCH={os.environ.get("ARCH", "linux/arm64")}" '
                   f'--build-arg="JAVA_VERSION={config["java_version"]}" '
                   f'{pathlib.Path(__file__).parent.resolve()}/..')
        print(command)
        os.system(command)
