#!/usr/bin/env bats

@test "Play pulls creds from group all" {
  vault kv put secret/ansible/groups/all ansible_user=testuser ansible_password=testpassword othervar=HelloWorld
  VAULT_SKIP_VERIFY=1 \
    VAULT_TOKEN=root \
    VAULT_ADDR=http://127.0.0.1:8200 \
    ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no" \
    HASHIVAULT_VARS_DEBUG=1 \
    ansible-playbook -i 0100_hosts 0100_test.yml -vvv
  # echo $? >&2
  # /bin/false
}
