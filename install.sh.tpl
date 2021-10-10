#!/bin/bash -xe
sudo localedef -c -f UTF-8 -i en_US en_US.UTF-8
export LC_ALL=en_US.UTF-8
echo "* soft nofile 1024"  | sudo tee -a /etc/security/limits.conf
echo "* hard nofile 65536"  | sudo tee -a /etc/security/limits.conf

###install packages
sudo yum install -y wget unzip zip java-1.8.0-openjdk git nginx python3 libgfortran
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

##adding user
sudo useradd dataiku || true
echo "dataiku ALL=(ALL) NOPASSWD:ALL"  | sudo tee -a /etc/sudoers
echo "export PATH=\"\$PATH:/usr/local/bin\""  | sudo tee -a /home/dataiku/.bashrc
sudo groupadd docker
sudo usermod -aG docker dataiku

###mounting disk
sudo mkdir -p /home/dataiku/dss_data
sudo chown dataiku:dataiku /home/dataiku/dss_data
yes | sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb 
sudo mount -o discard,defaults /dev/sdb /home/dataiku/dss_data
echo "/dev/sdb          /home/dataiku/dss_data               ext4 defaults" | sudo tee -a  /etc/fstab

###install dataiku dss
#su dataiku
#cd /home/dataiku
wget https://downloads.dataiku.com/public/studio/8.0.1/dataiku-dss-8.0.1.tar.gz;wget https://downloads.dataiku.com/public/studio/8.0.1/dataiku-dss-hadoop-standalone-libs-generic-hadoop3-8.0.1.tar.gz;wget https://downloads.dataiku.com/public/studio/8.0.1/dataiku-dss-spark-standalone-8.0.1-2.4.5-generic-hadoop3.tar.gz
#tar xvf dataiku-dss-spark-standalone-8.0.1-2.4.5-generic-hadoop3.tar.gz
