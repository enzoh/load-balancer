#!/usr/bin/env ruby
#
# File        : default.rb
# Description : Provisioning script.
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
# This recipe configures a single-node Consul cluster.
##

include_recipe "apt"

apt_update "apt" do
	action :update
end

apt_package "unzip"

user "consul" do
	action :create
	home "/home/consul"
	password "$1$Iro6Z7x5$RXYoHJiOucEhgR/70Td0v1"
	shell "/bin/bash"
	supports :manage_home => true
end

for path in ["/etc/consul.d", "/opt/consul", "/var/www"]
	directory path do
		group "consul"
		mode "0755"
		owner "consul"
	end
end

for name in ["app", "config"]
	cookbook_file "/etc/consul.d/#{name}.json" do
		group "consul"
		mode "0644"
		owner "consul"
		source "#{name}.json"
	end
end

remote_file "/tmp/consul_0.6.4_linux_amd64.zip" do
	action :create
	checksum "abdf0e1856292468e2c9971420d73b805e93888e006c76324ae39416edcf0627"
	group "consul"
	mode "0644"
	owner "consul"
	source "https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip"
end

remote_file "/tmp/consul_0.6.4_web_ui.zip" do
	action :create
	checksum "5f8841b51e0e3e2eb1f1dc66a47310ae42b0448e77df14c83bb49e0e0d5fa4b7"
	group "consul"
	mode "0644"
	owner "consul"
	source "https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_web_ui.zip"
end

execute "unzip /tmp/consul_0.6.4_linux_amd64.zip" do
	cwd "/usr/local/bin"
	not_if { File.exist?("/usr/local/bin/consul") }
end

execute "unzip /tmp/consul_0.6.4_web_ui.zip" do
	cwd "/var/www"
	not_if { File.exist?("/var/www/index.html") }
end

bash "consul" do
	code <<-EOH
		set -m
		LOG_FILE=/var/log/consul.log
		PID_FILE=/run/consul.pid
		if [ -f $PID_FILE ]; then
			kill -15 $(cat $PID_FILE)
			rm $PID_FILE
		fi
		nohup consul agent -config-dir=/etc/consul.d > $LOG_FILE 2>&1 &
		echo $! > $PID_FILE
	EOH
	user "root"
end
