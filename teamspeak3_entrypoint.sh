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
    if [ ! -d $TEAMSPEAK_DATAFOLDER/$directory ]; then	
        mkdir -p $TEAMSPEAK_DATAFOLDER/$directory
    fi

    # Recreate symlink
    rm -rf $TEAMSPEAK_INSTALLDIR/$directory
    ln -sf $TEAMSPEAK_DATAFOLDER/$directory $TEAMSPEAK_INSTALLDIR/$directory	
done

# Symlink files
for file in "${file_links[@]}"
do
    # Create file in volume if it doesn't exist
    if [ ! -f $TEAMSPEAK_DATAFOLDER/$file ]; then
        touch $TEAMSPEAK_DATAFOLDER/$file
    fi

    # Recreate symlink
    rm -f $TEAMSPEAK_INSTALLDIR/$file
    ln -sf $TEAMSPEAK_DATAFOLDER/$file $TEAMSPEAK_INSTALLDIR/$file
done

# Symlink optional files
for file in "${optional_file_links[@]}"
do
    # Create symlink to file if it exists
    if [ -f $TEAMSPEAK_DATAFOLDER/$file ]; then
        ln -sf $TEAMSPEAK_DATAFOLDER/$file $TEAMSPEAK_INSTALLDIR/$file
    fi
done

# Set correct ownership and start Teamspeak server
chown -RL teamspeak3:teamspeak3 $TEAMSPEAK_INSTALLDIR
export LD_LIBRARY_PATH=".:$LD_LIBRARY_PATH"
exec start-stop-daemon --start --chuid teamspeak3:teamspeak3 --chdir $TEAMSPEAK_INSTALLDIR --exec $TEAMSPEAK_INSTALLDIR/ts3server_linux_amd64
