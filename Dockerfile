FROM debian:jessie
MAINTAINER Michael.Bortlik@gmail.com

# Set environment variables for build and entrypoint
ENV TEAMSPEAK_VERSION="3.0.11.4" \
    TEAMSPEAK_SHA1="09e7fc2cb5dddf84f3356ddd555ad361f5854321" \
    TEAMSPEAK_DATA_FOLDER="/teamspeak3" \
    INSTALL_DIR="/opt"

# Add user and group for the service to run under
RUN groupadd -r teamspeak3 \
 && useradd -r -g teamspeak3 teamspeak3

# Install wget
RUN apt-get update \
 && apt-get install -y wget --no-install-recommends \
 && rm -r /var/lib/apt/lists/*

# Download TS3 file and extract it into the install directory (env)
RUN wget -O ${INSTALL_DIR}/teamspeak3-server_linux-amd64.tar.gz http://dl.4players.de/ts/releases/${TEAMSPEAK_VERSION}/teamspeak3-server_linux-amd64-${TEAMSPEAK_VERSION}.tar.gz \
 && echo "${TEAMSPEAK_SHA1} ${INSTALL_DIR}/teamspeak3-server_linux-amd64.tar.gz" | sha1sum -c - \
 && tar -C ${INSTALL_DIR} -xzf ${INSTALL_DIR}/teamspeak3-server_linux-amd64.tar.gz \
 && rm ${INSTALL_DIR}/teamspeak3-server_linux-amd64.tar.gz
	 
# Volume for persistent data and configuration files
VOLUME ${TEAMSPEAK_DATA_FOLDER}

# Expose the TS3 Ports Default: 9987, ServerQuery: 10011, File: 30033
EXPOSE 9987/udp 10011 30033
	 
# Add entrypoint script and set its permissions
ADD /teamspeak3_entrypoint.sh /
RUN chmod +x /teamspeak3_entrypoint.sh
ENTRYPOINT ["/teamspeak3_entrypoint.sh"]