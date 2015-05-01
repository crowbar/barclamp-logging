# Copyright 2011, Dell
# Copyright 2014, SUSE Linux GmbH.
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

return if node[:platform] == "windows"

include_recipe "logging::common"

env_filter = " AND environment:#{node[:logging][:config][:environment]}"
servers = search(:node, "roles:logging\\-server#{env_filter}")

if servers.nil?
  servers = []
else
  servers = servers.map { |x| Chef::Recipe::Barclamp::Inventory.get_network_by_type(x, "admin").address }
end

if File.exists? "/etc/rsyslog.d/10-crowbar-client.conf"
  # Upgrade path: we used to create that file
  file "/etc/rsyslog.d/10-crowbar-client.conf" do
    action :delete
  end
end

template "/etc/rsyslog.d/99-crowbar-client.conf" do
  owner "root"
  group "root"
  mode 0644
  source "rsyslog.client.erb"
  variables(:servers => servers)
  notifies :restart, "service[rsyslog]"
end
