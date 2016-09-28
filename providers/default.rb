#
# Cookbook Name:: nodejs-webapp
# Provider:: default
#
# Copyright 2015, Oregon State University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Separate resource into own context
use_inline_resources

action :install do
  run_context.include_recipe 'git'
  run_context.include_recipe 'build-essential'
  run_context.include_recipe 'pm2'

  magic_shell_environment 'PATH' do
    value '/usr/local/bin:$PATH'
  end

  # If the new_resource.path is nil set the install path to
  # `/opt/name_attribute`
  path = new_resource.path || "/opt/#{new_resource.name}"

  group new_resource.group do
    action :create
  end

  user new_resource.user do
    action :create
    gid new_resource.group
  end

  directory path do
    action :create
    recursive true
    user new_resource.user
    group new_resource.group
  end

  # upgrade npm to latest version
  bash 'upgrade npm' do
    code 'npm -g install npm'
  end

  # hacky fix to prevent filling up /tmp due to bug with npm
  execute 'Clear temp files' do
    command "find /tmp -depth -iname 'npm-*' -type d -exec rm -r \"{}\" \\;"
    action :run
  end

  git path do
    action :sync
    repository new_resource.repository
    revision new_resource.branch
    destination "#{path}/source"
    user new_resource.user
    group new_resource.group
  end

  if new_resource.install_deps # ~FC023
    bash "#{new_resource.name}: npm install" do
      user 'root'
      cwd "#{path}/source"
      code <<-EOH
        npm install
      EOH
    end
  end

  # If we're working as root, we need to use /root instead of /home/root
  pm2_home = "/home/#{new_resource.user}"
  pm2_home = '/root' if new_resource.user == 'root'

  # evaluate the resource name at evaluation time to avoid context problem
  pm2_application new_resource.name do
    user new_resource.user
    script new_resource.script
    cwd "#{path}/source"
    home pm2_home
    node_args new_resource.node_args
    env new_resource.env
    action [:deploy, :start_or_reload]
  end

  # because pm2 can only write one startup script at a time, we're limited to
  # running it under one user.
  bash 'automatically start pm2' do
    code <<-EOH
      pm2 startup centos -u #{new_resource.user} --hp /home/#{new_resource.user}
    EOH
    env new_resource.env
  end

  # pm2 automatically searches its user's home directory for a dump on start.
  # After reboot, it will automatically load apps stored here, so update that
  # file with all of the currently running applications.
  bash 'dump pm2 config' do
    user new_resource.user
    code "HOME=#{pm2_home} pm2 save"
    env new_resource.env
  end

  new_resource.updated_by_last_action(true)
end
