#!/usr/bin/env bash

set -eo pipefail

DOCTL_CHECKSUM=914b3c9ea654327c4eb6aa9abdf19df1c115067ee8bce4e2309708d908a1885b
DOCTL_VERSION=1.64.0

HELM_3_CHECKSUM=07c100849925623dc1913209cd1a30f0a9b80a5b4d6ff2153c609d11b043e262
HELM_3_VERSION=3.6.3

KUBECTL_CHECKSUM=a2ccab98460d80c9dcbc4c776e373c88e0921883da05610e17acf51e6f1c50a46891482cc62720647c1488e9e79986f61c90574a095a98a4e90806065089d5ef
KUBECTL_VERSION=1.21.3

setup() {
    mkdir /lib64
    ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
    apk add --no-cache wget
}

teardown() {
    apk del wget
}

install_doctl() {
    wget https://github.com/digitalocean/doctl/releases/download/v${DOCTL_VERSION}/doctl-${DOCTL_VERSION}-linux-amd64.tar.gz

    echo "${DOCTL_CHECKSUM}  doctl-${DOCTL_VERSION}-linux-amd64.tar.gz" > doctl.checksum
    sha256sum -c doctl.checksum
    rm doctl.checksum

    tar zxvf doctl-${DOCTL_VERSION}-linux-amd64.tar.gz
    mv doctl /usr/local/bin/doctl
    chmod +x /usr/local/bin/doctl

    rm -rf doctl-${DOCTL_VERSION}-linux-amd64.tar.gz
}

install_helm_3() {
    wget https://get.helm.sh/helm-v${HELM_3_VERSION}-linux-amd64.tar.gz

    echo "${HELM_3_CHECKSUM}  helm-v${HELM_3_VERSION}-linux-amd64.tar.gz" > helm.checksum
    sha256sum -c helm.checksum
    rm helm.checksum

    tar zxvf helm-v${HELM_3_VERSION}-linux-amd64.tar.gz
    mv linux-amd64/helm /usr/local/bin/helm
    chmod +x /usr/local/bin/helm
    
    rm -rf helm-v${HELM_3_VERSION}-linux-amd64.tar.gz linux-amd64
}

install_kubectl() {
    wget https://dl.k8s.io/v${KUBECTL_VERSION}/kubernetes-client-linux-amd64.tar.gz

    echo "${KUBECTL_CHECKSUM}  kubernetes-client-linux-amd64.tar.gz" > kubectl.checksum
    sha512sum -c kubectl.checksum
    rm kubectl.checksum
    
    tar zxvf kubernetes-client-linux-amd64.tar.gz
    mv kubernetes/client/bin/kubectl /usr/local/bin/kubectl
    chmod +x /usr/local/bin/kubectl
    
    rm -rf kubernetes-client-linux-amd64.tar.gz kubernetes
}

setup
install_kubectl
install_helm_3
install_doctl
teardown
