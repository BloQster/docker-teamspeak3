#!/bin/bash
set -e


#for linking
potential_directory_links=('logs' 'files')
potential_file_links=('licensekey.dat' 'query_ip_blacklist.txt' 'query_ip_whitelist.txt' 'ts3server.sqlitedb' 'ts3server.ini')

#link directories
for directory in "${potential_directory_links[@]}"
do
	if[ -d $directory ]; then
		rm -rf /opt/teamspeak3-server_linux-amd64/$directory
		ln -sf $TEAMSPEAK_DATA_FOLDER/$directory /opt/teamspeak3-server_linux-amd64/$directory
	fi	
done

#link files
for file in "${potential_files_links[@]}"
do
	if[ -f $file ]; then
		rm -rf /opt/teamspeak3-server_linux-amd64/$file
		ln -sf $TEAMSPEAK_DATA_FOLDER/$file /opt/teamspeak3-server_linux-amd64/$file
	fi	
done

# Start Teamspeak server
exec start-stop-daemon --start --chuid teamspeak3:teamspeak3 --exec 
