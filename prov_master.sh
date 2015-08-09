#!/bin/bash

scp openstack.id_rsa core@67.205.56.81:~/.ssh/id_rsa
scp kube-serviceaccount.key core@67.205.56.81:~/
ssh core@67.205.56.81 "sudo wget -P /opt/bin https://storage.googleapis.com/kubernetes-release/release/v1.0.1/bin/$(uname -s | tr '[:upper:]' '[:lower:]')/amd64/kubectl"
ssh core@67.205.56.81 "sudo chmod +x /opt/bin/kubectl"
rsync -avz ./dns core@67.205.56.81:~/
