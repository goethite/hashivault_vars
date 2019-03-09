# Ansible Vars Plugin for Hashicorp Vault

| Latest | | | |
|:-|:-|:-|:-|
|![](https://img.shields.io/pypi/v/hashivault-vars.svg)|![](https://img.shields.io/pypi/status/hashivault-vars.svg)|![](https://img.shields.io/pypi/format/hashivault-vars.svg)|![](https://img.shields.io/pypi/l/hashivault-vars.svg)|

| PyPi | | |
|:-|:-|:-|
|[![Downloads](https://pepy.tech/badge/hashivault-vars)](https://pepy.tech/project/hashivault-vars) | [![Downloads](https://pepy.tech/badge/hashivault-vars/month)](https://pepy.tech/project/hashivault-vars) | [![Downloads](https://pepy.tech/badge/hashivault-vars/week)](https://pepy.tech/project/hashivault-vars)|

An Ansible Vars Plugin for Hashicorp Vault to lookup credentials/secrets,
injecting these into the playbook run (e.g. `ansible_user`, `ansible_password`,
etc).

Use Hashicorp Vault like you would ansible-vault'ed group_vars,
domain_vars [a new concept in this module!] and host_vars.

This module was originaly developed for the [gostint](https://goethite.github.io/gostint/)
project.

## Installation

```bash
sudo pip install hashivault-vars
```

## Enable in Ansible
Symlink from ansible's vars plugins folder to `hashivault_vars.py`, e.g.:
```bash
$ cd /usr/local/lib/python2.7/dist-packages/ansible/plugins/vars
$ sudo ln -s /usr/local/lib/python2.7/dist-packages/hashivault_vars/hashivault_vars.py .
```

On Alpine Linux:
```bash
pip install hvac hashivault-vars && \
ln -s /usr/lib/python2.7/site-packages/hashivault_vars/hashivault_vars.py \
  /usr/lib/python2.7/site-packages/ansible/plugins/vars
```

## Vault Secret Paths
Root path in vault:

* `/secret/ansible/`

Precendence (applied top to bottom, so last takes precendence):
* Groups:
  * `/secret/ansible/groups/all`
  * `/secret/ansible/groups/ungrouped`
  * `/secret/ansible/groups/your_inv_item_group`
  * ...

* Hosts/Domains:
  * `/secret/ansible/{connection}/domains/com`
  * `/secret/ansible/{connection}/domains/example.com`
  * `/secret/ansible/{connection}/hosts/hosta.example.com`

where `{connection}` is `ansible_connection`, e.g.: "ssh", "winrm", ...
(this plugin attempts to make assumptions where `ansible_connection` is not
set)

All values retrieved from these paths are mapped as ansible variables,
e.g. `ansible_user`, `ansible_password`, etc.

The layered lookups are merged, with the last taking precendence over
earlier lookups.

Lookups to the vault are cached for the run.

## Developer Notes

### Enable Debugging
(danger, will reveal retrieved vault secrets in the ansible log)

Set environment variable `HASHIVAULT_VARS_DEBUG=1`.

### Release to PyPi
From vagrant (pip prereqs are required), e.g.:
```bash
$ ./setup.py sdist bdist_wheel
$ twine upload dist/hashivault_vars-0.1.17*
```
