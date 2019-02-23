# Ansible Vars Plugin for Hashicorp Vault

Use Hashicorp Vault like you would ansible-vault'ed group_vars,
domain_vars [a new concept in this module!] and host_vars.

This module was developed for the [gostint](https://goethite.github.io/gostint/)
project.

## Installation

```bash
sudo pip install hashivault_vars
```

## Enable in Ansible
Symlink from ansible's vars plugins folder to `hashivault_vars.py`:
```bash
$ cd /usr/local/lib/python2.7/dist-packages/ansible/plugins/vars
$ sudo ln -s /usr/local/lib/python2.7/dist-packages/hashivault_vars/hashivault_vars.py .
```
(This is done automatically if ansible was also installed using pip)
