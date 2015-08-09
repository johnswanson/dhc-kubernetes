#!/bin/bash -xe

NUM_NODES=4
KUBERNETES_VERSION=1.0.1
MASTER_IP=192.168.100.23
CHANNEL=alpha
CLOUD_PROVIDER=""
DNS_DOMAIN=cluster.local

PUBKEY=openstack.id_rsa.pub

make_keypair () {
		nova keypair-delete coreos || echo "didn't already exist, that's ok"
		nova keypair-add --pub-key $PUBKEY coreos
}

name () {
		local res=$(printf "node%02d" "$1")
		echo "$res"
}

prepare_kubectl_install () {
		cp setup.tmpl /tmp/setup
		setup "" "setup"
		chmod +x /tmp/setup
}

kubectl_install () {
		/tmp/setup
}

prepare () {
		node_name=$(name $1)
		cp node.yaml /tmp/node.yaml
		setup $node_name "node.yaml"
		chmod +x /tmp/node.yaml
}

setup () {
		NAME="$1"
		FILE="$2"
		sed -e "s|__KUBERNETES_VERSION__|${KUBERNETES_VERSION}|g" -i'' /tmp/$FILE
		sed -e "s|__MASTER_IP__|${MASTER_IP}|g" -i'' /tmp/$FILE
		sed -e "s|__CHANNEL__|${CHANNEL}|g" -i'' /tmp/$FILE
		sed -e "s|__CLOUD_PROVIDER__|${CLOUD_PROVIDER}|g" -i'' /tmp/$FILE
		sed -e "s|__DNS_DOMAIN__|${DNS_DOMAIN}|g" -i'' /tmp/$FILE
		sed -e "s|__NAME__|${NAME}|g" -i'' /tmp/$FILE
}

launch () {
		node_name=$(name "$1")
		nova boot --user-data /tmp/node.yaml              \
				 --image f044ae8f-e0e1-4fb4-baff-0363c19a6638 \
				 --key-name coreos                            \
				 --flavor 400                                 \
				 --num-instances 1                            \
				 --security-groups default                    \
				 --config-drive true $node_name
}

make_keypair

for i in `seq 1 $NUM_NODES`
do
		printf "preparing node %d ..." $i
		prepare $i
		printf "launching node %d ... " $i
		launch $i
		printf "launched!"
done

prepare_kubectl_install
kubectl_install
