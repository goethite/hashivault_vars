#!/bin/bash -e

echo
echo "***************************"
echo "*** Starting BATS Tests ***"
echo "***************************"
echo

vault login root >/dev/null

# cleanup
(
vault kv delete secret/ansible/groups/all
vault kv delete secret/ansible/groups/my.com
vault kv delete secret/ansible/local/domains/localdomain
vault kv delete secret/ansible/local/hosts/localhost.localdomain
vault kv delete secret/ansible/myroot/groups/all
) || /bin/true
