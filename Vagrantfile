# -*- mode: ruby -*-
# vi: set ft=ruby :

extras = "src/scripts/init_dev.sh"

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "ansible", primary: true do |ansible|
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
