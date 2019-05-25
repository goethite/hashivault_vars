#!/bin/bash -e

echo
echo "***************************"
echo "*** Starting BATS Tests ***"
echo "***************************"
echo

echo $PATH
export PATH=/usr/local/bin:$PATH
echo $PATH

vault login root
