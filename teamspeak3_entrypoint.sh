#!/bin/bash
set -e

# Declare files and directories for symlinking
directory_links=('logs' 'files')
file_links=('query_ip_blacklist.txt' 'query_ip_whitelist.txt' 'ts3server.sqlitedb')
optional_file_links=('ts3server.ini' 'licensekey.dat' 'serverkey.dat')

# Symlink directories
for directory in "${directory_links[@]}"
do
    # Create directory in volume if it doesn't exist
    if [ ! -d $TEAMSPEAK_DATA_FOLDER/$directory ]; then	
        mkdir $TEAMSPEAK_DATA_FOLDER/$directory
    fi

    # Recreate symlink
    rm -rf $INSTALL_DIR/teamspeak3-server_linux-amd64/$directory
    ln -sf $TEAMSPEAK_DATA_FOLDER/$directory $INSTALL_DIR/teamspeak3-server_linux-amd64/$directory	
done

# Symlink files
for file in "${file_links[@]}"
do
    # Create file in volume if it doesn't exist
    if [ ! -f $TEAMSPEAK_DATA_FOLDER/$file ]; then
        touch $TEAMSPEAK_DATA_FOLDER/$file
    fi	

    # Recreate symlink
    rm -rf $INSTALL_DIR/teamspeak3-server_linux-amd64/$file
    ln -sf $TEAMSPEAK_DATA_FOLDER/$file $INSTALL_DIR/teamspeak3-server_linux-amd64/$file
done

# Symlink optional files
for file in "${optional_file_links[@]}"
do
    # Create symlink to file if it exists
    if [ -f $TEAMSPEAK_DATA_FOLDER/$file ]; then
        ln -sf $TEAMSPEAK_DATA_FOLDER/$file $INSTALL_DIR/teamspeak3-server_linux-amd64/$file
    fi
done

# Set correct ownership and start Teamspeak server
chown -RL teamspeak3:teamspeak3 $INSTALL_DIR/teamspeak3-server_linux-amd64
export LD_LIBRARY_PATH=".:$LD_LIBRARY_PATH"
exec start-stop-daemon --start --chuid teamspeak3:teamspeak3 --chdir $INSTALL_DIR/teamspeak3-server_linux-amd64 --exec $INSTALL_DIR/teamspeak3-server_linux-amd64/ts3server_linux_amd64
