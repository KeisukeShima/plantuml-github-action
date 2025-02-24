FROM ghcr.io/plantuml/plantuml:latest
# Current plantUML version at time of switch: PlantUML Version 1.2020.02
# Note: GitHub Actions must be run by the default Docker user (root). Ensure your Dockerfile does not set the USER instruction, otherwise you will not be able to access GITHUB_WORKSPACE.

# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199
RUN mkdir -p /usr/share/man/man1

RUN apt-get -qy update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install fonts-ipafont fonts-ipaexfont fonts-takao-gothic && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
