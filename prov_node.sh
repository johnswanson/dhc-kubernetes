#!/bin/bash
# must be run from the master!!!!

HOST="$1"

ssh core@$HOST "sudo sed -e 's|--oem=ec2-compat|--from-ec2-metadata=http://169.254.169.254/|g' -i'' /usr/share/oem/cloud-config.yml"
ssh core@$HOST "update_engine_client -update"
