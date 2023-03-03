#!/bin/bash

#Making argument to variable
CP_USER=$1

#Entering cPanel user CURRENT ES instance configuration
cd /home/$CP_USER/.elasticsearch/latest/config

#Copy the config files
cp jvm.options elasticsearch.yml ../../

#Stopping the ES instance for that cPanel user
service elasticsearch@$CP_USER stop

#Removing the CURRENT symlink
unlink /home/$CP_USER/.elasticsearch/latest

#Ensureing we are in the ES root folder
cd /home/$CP_USER/.elasticsearch

#Downloading ES 7.17.9 version from the official repo
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.9-linux-x86_64.tar.gz

#Extract the downloaded ES
tar -zxf elasticsearch-7.17.9-linux-x86_64.tar.gz

#Rename ES folder
mv elasticsearch-7.17.9/ 7.17.9

#Remove the ES archive
rm -f elasticsearch-7.17.9-linux-x86_64.tar.gz

#Remove the default configuration files
rm -f /home/$CP_USER/.elasticsearch/7.17.9/config/jvm.options /home/$CP_USER/.elasticsearch/7.17.9/config/elasticsearch.yml

#Move our CURRENT config to the new ES version
mv /home/$CP_USER/.elasticsearch/jvm.options /home/$CP_USER/.elasticsearch/elasticsearch.yml /home/$CP_USER/.elasticsearch/7.17.9/config

#Creating and setting new VERSION file
echo "7.17.9" > /home/$CP_USER/.elasticsearch/7.17.9/VERSION

#Creating new symlink
ln -s /home/$CP_USER/.elasticsearch/7.17.9 /home/$CP_USER/.elasticsearch/latest

#Ensuring the new ES folder have the correct ownership
chown $CP_USER. -R /home/$CP_USER/.elasticsearch/7.17.9/

#Ensuring the new latest symlink have the correct ownership
chown $CP_USER. -h /home/$CP_USER/.elasticsearch/latest

#Starting the new ES instance for that cPanel user
service elasticsearch@$CP_USER start

#Print us the status of the new ES instance
service elasticsearch@$CP_USER status
