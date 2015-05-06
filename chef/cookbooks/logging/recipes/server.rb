# Copyright 2011, Dell
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "logging::common"

external_servers = node[:logging][:external_servers]
rsyslog_version = `rsyslogd -v | head -1 | cut -d " " -f 2`

directory "/var/log/nodes" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

# We can't be server and client, so remove client file if we were client before
# No restart notification, as this file can only exist if the node moves from
# client to server, and in that case, the notification for the template below
# will create a notification.
file "/etc/rsyslog.d/99-crowbar-client.conf" do
  action :delete
end

template "/etc/rsyslog.d/10-crowbar-server.conf" do
  owner "root"
  group "root"
  mode 0644
  source "rsyslog.server.erb"
  variables(:external_servers => external_servers, :rsyslog_version => rsyslog_version)
  notifies :restart, "service[rsyslog]"
end

if node.platform == "ubuntu"
  # dropping privileges seems to not allow network ports < 1024.
  # so, don't drop privileges.
  utils_line "# don't drop user privileges to keep network" do
    action :add
    regexp_exclude '\$PrivDropToUser\s+syslog\s*'
    file "/etc/rsyslog.conf"
    notifies :restart, "service[rsyslog]"
  end

  utils_line "# don't drop group privileges to keep network" do
    action :add
    regexp_exclude '\$PrivDropToGroup\s+syslog\s*'
    file "/etc/rsyslog.conf"
    notifies :restart, "service[rsyslog]"
  end
end
