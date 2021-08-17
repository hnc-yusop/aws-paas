#!/bin/bash
mkdir -p cert
ssh-keygen -f cert/terraform
mv cert/terraform cert/terraform.pem
chmod 400 cert/terraform.pem
