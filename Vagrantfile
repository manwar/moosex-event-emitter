# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	config.vm.hostname = "moosex-event-emitter"
	config.vm.box = "ubuntu/xenial64"

	config.vm.provision "shell", inline: <<-SHELL
		apt-get update

		apt-get install -y build-essential
		apt-get install -y curl

		curl -sL http://cpanmin.us | perl - App::cpanminus

		cpanm Module::Build

		echo "installdeps --cpan_client='cpanm --mirror http://cpan.org'" | tee $HOME/.modulebuildrc
	SHELL
end
