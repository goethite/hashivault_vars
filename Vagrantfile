# -*- mode: ruby -*-
# vi: set ft=ruby :

extras = "
cd src && \
scripts/init_dev.sh && \
echo 'export VAULT_ADDR=http://127.0.0.1:8200' >> ~vagrant/.bashrc
"

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "ansible", primary: true do |ansible|
    ansible.vm.usable_port_range = 2300..2350
    ansible.vm.provision "shell", inline: extras
    ansible.vm.synced_folder "./", "/home/vagrant/src/"
    ansible.vm.provider "docker" do |d|
      d.image = "gbevan/vagrant-ubuntu-dev:bionic"
      d.has_ssh = true
      d.volumes = [
        "/etc/localtime:/etc/localtime:ro",
        "/etc/timezone:/etc/timezone:ro"
      ]
    end
  end
end
