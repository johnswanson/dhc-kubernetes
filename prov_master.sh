#!/bin/bash

nova floating-ip-associate master 67.205.56.81
sleep 5
scp openstack.id_rsa core@67.205.56.81:~/.ssh/id_rsa
scp kube-serviceaccount.key core@67.205.56.81:~/
ssh core@67.205.56.81 "sudo sed -e 's|--oem=ec2-compat|--from-ec2-metadata=http://169.254.169.254/|g' -i'' /usr/share/oem/cloud-config.yml"
ssh core@67.205.56.81 "sudo iptables -A INPUT -p tcp --dport 8080 -s 192.168.0.1/16 -j ACCEPT"
ssh core@67.205.56.81 "sudo iptables -A INPUT -p tcp --dport 8080 -j DROP"
ssh core@67.205.56.81 update_engine_client -update
