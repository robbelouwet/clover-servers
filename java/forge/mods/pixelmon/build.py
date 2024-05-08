import json
import os
import pathlib
import sys

if __name__ == "__main__":
    fs = open(f'{pathlib.Path(__file__).parent.resolve()}/version_config.json', 'r')
    configs = json.load(fs)

    override_version = None
    if len(sys.argv) > 1:
        if str(sys.argv[1]) not in map(lambda c: c["minecraft_version"], configs):
            print(f"{sys.argv[1]} not an available minecraft version.")
            exit(1)
        else:
            override_version = str(sys.argv[1])

    for config in configs:
        if override_version is not None and config["minecraft_version"] != override_version: continue
        command = (f'docker build --no-cache '
                   f'-f java/forge/mods/pixelmon/Dockerfile '
                   f'-t robbelouwet/pixelmon:{config["minecraft_version"]} '
                   f'--build-arg="MOD_VERSION={config["mod_version"]}" '
                   f'--build-arg="MINECRAFT_VERSION={config["minecraft_version"]}" '
                   f'--build-arg="FORGE_VERSION={config["forge_version"]}" '
                   f'--build-arg="DOWNLOAD_LINK={config["download_link"]}" '
                   f'--build-arg="ARCH={os.environ.get("ARCH", "linux/arm64")}" '
                   f'{pathlib.Path(__file__).parent.resolve()}/../../..')
        print(command)
        os.system(command)
