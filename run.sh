#!/bin/bash
filename=VagrantFile

if [ -f "$filename" ];
then
    rm "$filename"
fi

./templates_generator.py
vagrant box update
vagrant up
