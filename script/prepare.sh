#!/bin/bash

INSTALLABLE_PKGS=""

function check_installable_pkgs()
{
    for arg in ${!1}
    do
        sudo dpkg -l ${arg} | grep ii
        if [ $? != 0 ]; then
            INSTALLABLE_PKGS="$INSTALLABLE_PKGS ${arg}"
        fi
    done
}

function install_aws_cli()
{
    PKGS=(awscli)

    check_installable_pkgs PKGS[@] > /dev/null
    if [ "$INSTALLABLE_PKGS" != "" ]; then
        sudo apt-get update && sudo apt-get install $INSTALLABLE_PKGS -y
    fi
}

function install_sam_cli()
{
    INSTALLED_SAM=`which sam`
    if [ "$INSTALLED_SAM" == "" ];then
        DN_URL=https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
        TMP_DIR=/tmp
        wget $DN_URL -P $TMP_DIR
        unzip $TMP_DIR/aws-sam-cli-linux-x86_64.zip -d $TMP_DIR/sam-installation
        sudo $TMP_DIR/sam-installation/install
        rm -rf $TMP_DIR/sam-installation
        rm -rf $TMP_DIR/aws-sam-cli-linux-x86_64.zip
        sam --version
    fi
}

function install_eksctl()
{
    INSTALLED_EKSCTL=`which eksctl`
    if [ "$INSTALLED_EKSCTL" == "" ];then
        curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
        sudo mv /tmp/eksctl /usr/local/bin
        eksctl version
    fi
}


function install_terraform()
{
    INSTALLED_TERRAFORM=`which terraform`
    if [ "$INSTALLED_TERRAFORM" == "" ];then
        sudo apt-get update && sudo apt-get install -y wget unzip

        TER_VER=`curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'`

        wget https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip

        unzip terraform_${TER_VER}_linux_amd64.zip
        sudo mv terraform /usr/local/bin/
        terraform -v
    fi
}

# main
install_aws_cli
install_sam_cli
install_eksctl

install_terraform
