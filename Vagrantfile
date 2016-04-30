#!/usr/bin/env ruby
#
# File        : Vagrantfile
# Description : Configuration file.
# Copyright   : Copyright (c) 2016 Mirror Labs, Inc. All rights reserved.
# Maintainer  : Enzo Haussecker <enzo@mirror.co>
# Stability   : Stable
# Portability : Portable
#
# NOTICE: Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# This file configures the development environment.
##

Vagrant.configure("2") do |config|

	config.vm.provider "virtualbox" do |vbox|
		vbox.customize ["modifyvm", :id, "--cpus", "2"]
		vbox.customize ["modifyvm", :id, "--memory", "8192"]
	end

	config.vm.define "consul" do |node|
		node.vm.box = "ubuntu/trusty64"
		node.vm.hostname = "consul.service.consul"
		node.vm.network "forwarded_port", guest: 8500, host: 8500
		node.vm.network "private_network", ip: "10.0.10.10"
		node.vm.provision "chef_solo" do |chef|
			chef.log_level = "info"
			chef.run_list = ["recipe[apt]", "recipe[service-discovery]"]
		end
	end

	config.vm.define "app1" do |node|
		node.vm.box = "ubuntu/trusty64"
		node.vm.hostname = "app1.service.consul"
		node.vm.network "private_network", ip: "10.0.10.11"
		node.vm.provision "chef_solo" do |chef|
			chef.log_level = "info"
			chef.run_list = ["recipe[apt]", "recipe[app-server]"]
		end
	end

	config.vm.define "app2" do |node|
		node.vm.box = "ubuntu/trusty64"
		node.vm.hostname = "app2.service.consul"
		node.vm.network "private_network", ip: "10.0.10.12"
		node.vm.provision "chef_solo" do |chef|
			chef.log_level = "info"
			chef.run_list = ["recipe[apt]", "recipe[app-server]"]
		end
	end

	config.vm.define "edge" do |node|
		node.vm.box = "ubuntu/trusty64"
		node.vm.hostname = "edge.service.consul"
		node.vm.network "forwarded_port", guest: 8000, host: 8000
		node.vm.network "private_network", ip: "10.0.10.13"
		node.vm.provision "chef_solo" do |chef|
			chef.log_level = "info"
			chef.run_list = ["recipe[apt]", "recipe[load-balancer]"]
		end
	end

end
