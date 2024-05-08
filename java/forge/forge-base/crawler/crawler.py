import json

import requests
from bs4 import BeautifulSoup
import re


def crawl_downloads():
    f = open('version_config.json', 'r')
    versions = json.load(f)
    versions_complete = []
    for e in versions:
        response = requests.get(
            f'https://files.minecraftforge.net/net/minecraftforge/forge/index_{e["minecraft_version"]}.html'
            ).content.decode()
        soup = BeautifulSoup(markup=response)

        html_download_node = str(soup.select(selector="div .download > div .link-boosted")[0])

        regex_download_link = re.search("url=(https:\/\/.*-installer\.jar)", html_download_node)
        regex_forge_version = re.search(f'forge-{e["minecraft_version"]}-(.*)-installer\.jar', html_download_node)

        versions_complete.append({
            "minecraft_version": e["minecraft_version"],
            "forge_version": regex_forge_version.group(1),
            "download_link": regex_download_link.group(1)
        })

    stream = open("version_config.json", "w")
    stream.write(json.dumps(versions_complete, indent=4))


if __name__ == "__main__":
    crawl_downloads()
