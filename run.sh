#!/bin/bash
./templates_generator.py
vagrant box update
vagrant up
