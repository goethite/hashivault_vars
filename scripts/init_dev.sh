#!/bin/bash -e

VAULTVER=1.1.0

sudo apt update
sudo apt install -y software-properties-common

sudo add-apt-repository -y ppa:duggan/bats
sudo apt update
sudo apt install -y python-pip sshpass libkrb5-dev bats

sudo pip install --upgrade pip setuptools wheel
sudo pip install \
    pip-tools \
		ansible==2.7.6 \
    botocore==1.12.86 \
		boto==2.49.0 \
		boto3==1.9.86 \
		awscli==1.16.96 \
    pywinrm[kerberos]==0.3.0 \
    pretty_json \
    twine
sudo pip install -r requirements.txt

sudo bash -c 'cat >> /etc/hosts' <<EOF
127.0.0.100     localhost.localdomain
EOF

# Install and start Vault server in dev mode
wget -qO /tmp/vault.zip https://releases.hashicorp.com/vault/${VAULTVER}/vault_${VAULTVER}_linux_amd64.zip && \
   ( cd /usr/local/bin && sudo unzip -u /tmp/vault.zip )
rm /tmp/vault.zip
vault -autocomplete-install
echo '=== Starting vault =================================='
(
  cd /tmp
  nohup vault server -dev \
    -dev-root-token-id=root \
    -dev-listen-address="0.0.0.0:8200" \
    >vault.log 2>&1 &
)

export VAULT_ADDR=http://127.0.0.1:8200

# Login to vault and configure
echo '=== Logging in to vault =================================='
sleep 5
vault login root

echo '=== Mocking production mounts of secret engines =========='
vault secrets move secret/ kv/  # v2 at /kv
vault secrets enable -path=secret/ -version=1 kv
