#!/bin/bash

REGION=ap-northeast-2

function conf_eksctl()
{
  eksctl create cluster \
    --name rancher-server \
    --version 1.18 \
    --region $REGION \
    --nodegroup-name ranchernodes \
    --nodes 3 \
    --nodes-min 2 \
    --nodes-max 4 \
    --managed
}

function check_created_cluster()
{
  echo "------- Check your cluster -------"
  eksctl get cluster
}

function nginx_ctrl()
{
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm repo update
  helm upgrade --install \
    ingress-nginx ingress-nginx/ingress-nginx \
    --namespace ingress-nginx \
    --set controller.service.type=LoadBalancer \
    --version 3.12.0 \
    --create-namespace
}

function get_lb_ip() 
{
  kubectl get service ingress-nginx-controller --namespace=ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
}

conf_eksctl
check_created_cluster
nginx_ctrl

echo "Waiting 10 seconds....."
sleep 10

HOSTNAME=`get_lb_ip`
echo $HOSTNAME
./install-rancher.sh $HOSTNAME
