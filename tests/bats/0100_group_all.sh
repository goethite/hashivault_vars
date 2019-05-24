#!/usr/bin/env bats

@test "Play pulls creds from group all" {
  vault kv put secret/ansible/groups/all ansible_user=vagrant ansible_password=vagrant
  cd ../../playbook
  ./run
  # echo $? >&2
  # /bin/false
}
