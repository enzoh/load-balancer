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
# This recipe configures a web server.
##

include_recipe "apt"

apt_update "apt" do
	action :update
end

directory "/var/www" do
	group "vagrant"
	mode "0755"
	owner "vagrant"
end

file "/var/www/index.html" do
	content "<HTML><BODY><H1>#{node.hostname}</H1></BODY></HTML>"	
	group "vagrant"
	mode "0644"
	owner "vagrant"
end

bash "python" do
	code <<-EOH
		set -m
		LOG_FILE=/var/log/app.log
		PID_FILE=/run/app.pid
		if [ -f $PID_FILE ]; then
			kill -15 $(cat $PID_FILE)
			rm $PID_FILE
		fi
		cd /var/www
		nohup python -m SimpleHTTPServer 8000 > $LOG_FILE 2>&1 &
		echo $! > $PID_FILE
	EOH
	user "root"
end
