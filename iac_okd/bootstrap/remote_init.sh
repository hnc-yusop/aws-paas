#!/bin/bash

# Reference URL : https://velog.io/@_gyullbb/OKD-4.7-%EC%84%A4%EC%B9%98

WORK_DIR=$HOME/workspace
INSTALL_DIR=$WORK_DIR/install

OKD_INSTALL_PKG_URL=https://github.com/openshift/okd/releases/download/4.7.0-0.okd-2021-08-07-063045/openshift-install-linux-4.7.0-0.okd-2021-08-07-063045.tar.gz

sudo yum -y install golang-bin gcc-c++ libvirt-devel
sudo yum -y install libvirt libvirt-devel libvirt-daemon-kvm qemu-kvm
sudo yum -y install wget 

# Retrieve installer
wget $OKD_INSTALL_PKG_URL
mkdir -p $INSTALL_DIR
tar -xvzf openshift-install*.tar.gz -C $WORK_DIR

# Retrieve client tool
OKD_CLIENT_INSTALL_PKG_URL=https://github.com/openshift/okd/releases/download/4.7.0-0.okd-2021-08-07-063045/openshift-client-linux-4.7.0-0.okd-2021-08-07-063045.tar.gz
EXTRACT_TMP_DIR=/tmp/openshift-client
mkdir $EXTRACT_TMP_DIR
wget -P $EXTRACT_TMP_DIR $OKD_CLIENT_INSTALL_PKG_URL
tar -xvzf $EXTRACT_TMP_DIR/openshift-client*.tar.gz -C $EXTRACT_TMP_DIR
sudo mv $EXTRACT_TMP_DIR/oc /usr/local/bin/
rm -rf $EXTRACT_TMP_DIR

ssh-keygen -t ed25519 -N '' -f ~/.ssh/okd
echo 'public key:'
echo '['
cat ~/.ssh/okd.pub
echo ']'

cd $WORK_DIR

echo '======= Preparing things ============'
echo '1) Platform : AWS'
echo '2) AWS Access Key ID'
echo '3) AWS Secret Access Key'
echo '4) Region'
echo '5) Base Domain'
echo '6) Cluster Name (subdomain으로 사용되기 때문에 소문자여야한다.)'
echo '7) Pull Secret -> https://cloud.redhat.com/openshift/install/pull-secret'
echo '====================================='
echo "Create configure file:"
echo "./openshift-install create install-config --dir=$INSTALL_DIR"
echo 
echo "Edit configure file:"
echo "vi $INSTALL_DIR/install-config.yaml"
echo 
echo "Create cluster:"
echo "./openshift-install create cluster --dir=$INSTALL_DIR --log-level=info"
echo 
echo "Destroy cluster :"
echo "./openshift-install destroy cluster --dir=$INSTALL_DIR --log-level=info"
