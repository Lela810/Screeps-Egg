#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

echo ":/home/container$ ${STARTUP} "

# Run the Server
eval ${STARTUP} 