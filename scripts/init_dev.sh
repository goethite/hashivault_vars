#!/bin/bash -e

VAULTVER=1.1.0

sudo apt update
sudo apt install -y software-properties-common

sudo add-apt-repository -y ppa:duggan/bats
sudo apt update
sudo apt install -y python3 python3-pip sshpass libkrb5-dev bats

sudo pip3 install --upgrade pip setuptools wheel
sudo pip3 install \
    pip-tools \
		ansible==2.8.2 \
		boto==2.49.0 \
		boto3==1.9.86 \
		awscli \
    pywinrm[kerberos]==0.3.0 \
    pretty_json \
    twine
sudo pip3 install -r requirements.txt

if
  grep "127.0.0.100" < /etc/hosts
then
  :
else
  sudo bash -c 'cat >> /etc/hosts' <<EOF
127.0.0.100     localhost.localdomain
EOF
fi

# Install and start Vault server in dev mode
wget -qO /tmp/vault.zip https://releases.hashicorp.com/vault/${VAULTVER}/vault_${VAULTVER}_linux_amd64.zip && \
   ( cd /usr/local/bin && sudo unzip -u /tmp/vault.zip )
rm /tmp/vault.zip
vault -autocomplete-install || /bin/true
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
