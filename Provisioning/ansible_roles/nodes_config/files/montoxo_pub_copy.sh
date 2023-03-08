#!/bin/bash
sshpass -p vagrant123 ssh root@192.168.0.17 cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys