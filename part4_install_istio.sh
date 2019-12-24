#!/bin/bash
#
# author: Gary A. Stafford
# site: https://programmaticponderings.com
# license: MIT License
# purpose: Install Istio 1.1.x
export ISTIO_HOME="/home/arty/Work/K8S/istio-1.4.2"

# helm repo add istio.io https://storage.googleapis.com/istio-prerelease/daily-build/master-latest-daily/charts
# helm repo list

kubectl apply -f ${ISTIO_HOME}/install/kubernetes/helm/helm-service-account.yaml

# helm init --service-account tiller

# Wait for Tiller pod to come up
# Error: could not find a ready tiller pod
echo 'Waiting 30 seconds...'
sleep 30

helm install ${ISTIO_HOME}/install/kubernetes/helm/istio-init \
  --generate-name \
  --namespace istio-system

# Wait for AKS, much slower than GKE :(
# echo 'Waiting 30 seconds...'
# sleep 30

helm install ${ISTIO_HOME}/install/kubernetes/helm/istio \
  --generate-name \
  --namespace istio-system \
  --set prometheus.enabled=true \
  --set grafana.enabled=true \
  --set kiali.enabled=true \
  --set tracing.enabled=true

# kubectl apply --namespace istio-system -f ./resources/secrets/kiali.yaml

# Wait for Pods to spin up
echo 'Waiting 30 seconds...'
sleep 30

kubectl get crds | grep 'istio.io\|certmanager.k8s.io' | wc -l

kubectl get svc -n istio-system
kubectl get pods -n istio-system
helm list istio
