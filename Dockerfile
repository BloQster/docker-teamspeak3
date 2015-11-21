FROM debian:latest
MAINTAINER Michael.Bortlik@gmail.com

# Definition
	# Set environment variables for docker and entrypoint
    ENV TEAMSPEAK_VERSION="3.0.11.4" \
     && TEAMSPEAK_SHA1="09e7fc2cb5dddf84f3356ddd555ad361f5854321" \
	 && TEAMSPEAK_DATA_FOLDER="/teamspeak3/"
	
    VOLUME [${TEAMSPEAK_DATA_FOLDER}]
	
    # Expose the TS3 Ports Default: 9987, ServerQuery: 10011, File: 30033
    EXPOSE 9987/udp 10011 30033

# Logic
    # Add user and group
    RUN groupadd -r teamspeak3
     && useradd -r -g teamspeak3 teamspeak3

    #Install wget
    RUN apt-get update \
     && apt-get install -y wget --no-install-recommends \
     && rm -r /var/lib/apt/lists/*

    # Download TS3 file and extract it into /opt.
    RUN wget -O teamspeak3-server_linux-amd64.tar.gz http://dl.4players.de/ts/releases/${TEAMSPEAK_VERSION}/teamspeak3-server_linux-amd64-${TEAMSPEAK_VERSION}.tar.gz \
     && sha1sum -c "${TEAMSPEAK_SHA1} *teamspeak3-server_linux-amd64.tar.gz" \
     && tar -C /opt -xzf teamspeak3-server_linux-amd64.tar.gz \
     && rm teamspeak3-server_linux-amd64.tar.gz

# Entrypoint
    # Add entrypoint script
    ADD /teamspeak3_entrypoint.sh
    RUN chmod +x /teamspeak3_entrypoint.sh
    ENTRYPOINT ["/teamspeak3_entrypoint.sh"]