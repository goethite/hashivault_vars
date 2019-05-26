#!/usr/bin/env bats

@test "Play pulls creds from group all" {
  vault kv put secret/ansible/groups/all ansible_user=testuser ansible_password=testpassword othervar=HelloWorld
  VAULT_SKIP_VERIFY=1 \
    VAULT_TOKEN=root \
    VAULT_ADDR=http://127.0.0.1:8200 \
    ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no" \
    HASHIVAULT_VARS_DEBUG=0 \
    ansible-playbook -i 0100_hosts 0100_test_all.yml
  RC=$?
  vault kv delete secret/ansible/groups/all
  return $RC
}

@test "Play pulls creds from group my.com" {
  vault kv put secret/ansible/groups/all ansible_user=testuser ansible_password=testpassword othervar=HelloWorld
  vault kv put secret/ansible/groups/my.com ansible_user=testuser ansible_password=testpassword othervar=MyCom
  VAULT_SKIP_VERIFY=1 \
    VAULT_TOKEN=root \
    VAULT_ADDR=http://127.0.0.1:8200 \
    ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no" \
    HASHIVAULT_VARS_DEBUG=0 \
    ansible-playbook -i 0100_hosts 0100_test_mycom.yml
  RC=$?
  vault kv delete secret/ansible/groups/my.com
  vault kv delete secret/ansible/groups/all
  return $RC
}

@test "Play pulls creds from domain localdomain" {
  vault kv put secret/ansible/groups/all ansible_user=testuser ansible_password=testpassword othervar=HelloWorld
  vault kv put secret/ansible/local/domains/localdomain ansible_user=testuser ansible_password=testpassword othervar=LocalDomain
  VAULT_SKIP_VERIFY=1 \
    VAULT_TOKEN=root \
    VAULT_ADDR=http://127.0.0.1:8200 \
    ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no" \
    HASHIVAULT_VARS_DEBUG=0 \
    ansible-playbook -i 0100_hosts 0100_test_localdomain.yml
  RC=$?
  vault kv delete secret/ansible/local/domains/localdomain
  vault kv delete secret/ansible/groups/all
  return $RC
}

@test "Play pulls creds from host localhost.localdomain" {
  vault kv put secret/ansible/groups/all ansible_user=testuser ansible_password=testpassword othervar=HelloWorld
  vault kv put secret/ansible/local/hosts/localhost.localdomain ansible_user=testuser ansible_password=testpassword othervar=LocalHost
  VAULT_SKIP_VERIFY=1 \
    VAULT_TOKEN=root \
    VAULT_ADDR=http://127.0.0.1:8200 \
    ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no" \
    HASHIVAULT_VARS_DEBUG=0 \
    ansible-playbook -i 0100_hosts 0100_test_localhost.yml
  RC=$?
  vault kv delete secret/ansible/local/hosts/localhost.localdomain
  vault kv delete secret/ansible/groups/all
  return $RC
}

@test "Play pulls creds from group all with different root path" {
  vault kv put secret/ansible/myroot/groups/all ansible_user=testuser ansible_password=testpassword othervar=HelloWorld
  VAULT_SKIP_VERIFY=1 \
    VAULT_TOKEN=root \
    VAULT_ADDR=http://127.0.0.1:8200 \
    ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no" \
    HASHIVAULT_VARS_DEBUG=1 \
    HASHIVAULT_VARS_ROOT_PATH="/secret/ansible/myroot" \
    ansible-playbook -i 0100_hosts 0100_test_all.yml
  RC=$?
  vault kv delete secret/ansible/myroot/groups/all
  return $RC
}
