#!/bin/bash

min_value=150
max_value=150
src=/etc/shadow
dest=/etc/shadow

for i in $(eval echo "{$min_value..$max_value}")
do 
    ip=192.168.0.${i}

    scp $src root@$ip:$dest
done