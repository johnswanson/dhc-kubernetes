#!/bin/bash

name () {
		local res=$(printf "node%02d" "$1")
		echo "$res"
}

NUM_NODES=4
for i in `seq 1 $NUM_NODES`
do
		nova delete $(name $i) || echo "failed to delete node " $(name $i)
done

nova delete master
