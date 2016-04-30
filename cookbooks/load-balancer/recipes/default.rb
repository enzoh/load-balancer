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
# This recipe configures a load balancer.
##

include_recipe "apt"

apt_update "apt" do
	action :update
end

apt_package "nginx"
apt_package "unzip"

directory "/templates" do
	group "vagrant"
	mode "0755"
	owner "vagrant"
end

cookbook_file "/templates/nginx.conf" do
	group "vagrant"
	mode "0644"
	owner "vagrant"
	source "nginx.conf"
end

remote_file "/tmp/consul-template_0.14.0_linux_amd64.zip" do
	action :create
	checksum "7c70ea5f230a70c809333e75fdcff2f6f1e838f29cfb872e1420a63cdf7f3a78"
	group "vagrant"
	mode "0644"
	owner "vagrant"
	source "https://releases.hashicorp.com/consul-template/0.14.0/consul-template_0.14.0_linux_amd64.zip"
end

execute "unzip /tmp/consul-template_0.14.0_linux_amd64.zip" do
	cwd "/usr/local/bin"
	not_if { File.exist?("/usr/local/bin/consul-template") }
end

bash "consul-template" do
	code <<-EOH
		set -m
		LOG_FILE=/var/log/consul-template.log
		PID_FILE=/run/consul-template.pid
		if [ -f $PID_FILE ]; then
			kill -15 $(cat $PID_FILE)
			rm $PID_FILE
		fi
		nohup consul-template \
		-consul=10.0.10.10:8500 \
		-template='/templates/nginx.conf:/etc/nginx/nginx.conf:service nginx reload' \
		> $LOG_FILE 2>&1 &
		echo $! > $PID_FILE
	EOH
	user "root"
end
