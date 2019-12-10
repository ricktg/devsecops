#!/bin/bash

mkdir -p $HOME/.kube
cp -f /etc/kubernetes/admin.conf $HOME/.kube/config

git clone https://github.com/ricktg/devsecops.git

cd devsecops-sympla/application

docker build -t simple-k8-app .
kubectl apply -f k8_deployment.yaml
kubectl apply -f k8_service.yaml
kubectl apply -f k8_ingress.yaml