#!/bin/bash

# make a new key for internal ssh
ssh-keygen -N "" -f openstack.id_rsa

nova boot \
		 --user-data ./master.yaml                                                     \
		 --image f044ae8f-e0e1-4fb4-baff-0363c19a6638                                  \
		 --key-name pico                                                               \
		 --nic net-id=ddb69e23-6449-4f5b-b6ad-548d1584c440,v4-fixed-ip=192.168.100.101 \
		 --flavor 400                                                                  \
		 --num-instances 1                                                             \
		 --security-groups default                                                     \
		 --config-drive true                                                           \
		 master

