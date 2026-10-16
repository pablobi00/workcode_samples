README

prepcentos8.sh file will prepare the OS to install CDH
Edit the top with the right default username to be used. 

cdhV7.sh will start the download of the CDH libraries and Cloudera Manager. 
Accept the license and defaults. 

If we need to build a local repository, the steps are: 

# ------ LOCAL REPOSITORY ----------------------------------------------------------------------------------------------

yum install -y yum-utils createrepo

# yum install httpd -y

systemctl enable httpd.service
systemctl status httpd.service
systemctl start httpd.service
systemctl status httpd.service

cd /etc/yum.repos.d/
reposync
yum -y update

# upload the file cloudera5.repo in /etc/yum.repos.d/ directory

cd /var/www/html
mkdir -p ./centos7/cdh

reposync -r cloudera-cdh5-161
createrepo /var/www/html/centos7/cdh/cloudera-cdh5-161


# ------ LOCAL REPOSITORY ----------------------------------------------------------------------------------------------

When we enter to install the CDH cluster we will change addresses to use the local repository.
Copy the file cloudera.repo.local to /etc/yum.repos.d/ edit Internal IP of the local repo server and rename it to cloudera.repo 

Couple of extra steps: 

yum install yum-plugin-priorities

Edit the /etc/yum/pluginconf.d/priorities.conf file to add the following:

[main]
enabled=1
gpgcheck=0


