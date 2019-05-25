#!/bin/bash -e

echo
echo "***************************"
echo "*** Starting BATS Tests ***"
echo "***************************"
echo

export PATH=/usr/local/bin:$PATH

export VAULT_ADDR=http://127.0.0.1:8200
vault login root
