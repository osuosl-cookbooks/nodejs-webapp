#
# Cookbook Name:: nodejs-webapp-test
# Recipe:: default
#
# Copyright 2015, Oregon State University
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

run_context.include_recipe 'git'
include_recipe 'build-essential'

node.override['nodejs']['install_method'] = 'binary'
node.override['nodejs']['version'] = '0.12.7'
node.override['nodejs']['binary']['checksum']['linux_x64'] = '6a2b3077f293d17e2a1e6dba0297f761c9e981c255a2c82f329d4173acf9b9d5'

# node and pm2 are installed to here
magic_shell_environment 'PATH' do
  value '/usr/local/bin:$PATH'
end

include_recipe 'pm2'

directory '/opt/timesync' do
  action :create
  recursive true
  owner 'root'
  group 'root'
end

git '/opt/timesync' do
  action :sync
  repository 'https://github.com/osuosl/timesync-node.git'
  revision 'develop'
  destination '/opt/timesync/source'
  user 'root'
  group 'root'
end

bash "timesync: npm install" do
  user 'root'
  cwd "/opt/timesync/source"
  code <<-EOH
    npm install
  EOH
end

bash 'timesync: npm run migrations' do
  user 'root'
  cwd "/opt/timesync/source"
  code <<-EOH
    npm run migrations
  EOH
end

pm2_application 'timesync' do
  script 'src/app.js'
  cwd '/opt/timesync/source'
  node_args ['--harmony']
  action [:deploy, :start_or_restart]
end
