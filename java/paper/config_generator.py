import json
import requests

if __name__ == "__main__":
    config = []
    # Get all the versions
    response = json.loads(requests.get("https://api.papermc.io/v2/projects/paper").content.decode())

    for version in response["versions"]:
        # Get the version's latest build
        resp_version = json.loads(
            requests.get(f"https://api.papermc.io/v2/projects/paper/versions/{version}")
            .content.decode())

        build = max(resp_version["builds"])

        # Download this build
        resp_build = json.loads(
            requests.get(f"https://api.papermc.io/v2/projects/paper/versions/{version}/builds/{build}")
            .content.decode())

        file = resp_build["downloads"]["application"]["name"]

        config.append({
            "version": version,
            "build": str(build),
            "channel": resp_build["channel"],
            "download_link": f"https://api.papermc.io/v2/projects/paper/versions/{version}/builds/{build}/downloads/{file}"
        })

    stream = open('version_config.json', 'w')
    stream.write(json.dumps(config, indent=4))
