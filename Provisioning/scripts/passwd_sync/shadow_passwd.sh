#!/bin/bash

min_value=1
max_value=1
src=/etc/shadow
dest=/etc/shadow

for i in $(eval echo "{$min_value..$max_value}")
do 
    ip=192.168.0.${i}

    scp $src root@$ip:$dest
done

scp $src root@192.168.0.150:$dest