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

action :install do
  # Use the git recipe to install git
  run_context.include_recipe 'git'
  run_context.include_recipe 'build-essential'
  run_context.include_recipe 'pm2'

  magic_shell_environment 'PATH' do
    value '/usr/local/bin:$PATH'
  end

  # If the new_resource.path is nil set the install path to
  # `/opt/name_attribute`
  path = new_resource.path || "/opt/#{new_resource.name}"

  if new_resource.create_user
    group new_resource.group do
      action :create
    end
    user new_resource.user do
      action :create
      gid new_resource.group
    end
  end

  directory path do
    action :create
    recursive true
    owner new_resource.user
    group new_resource.group
  end

  git path do
    action :sync
    repository new_resource.repository
    revision new_resource.branch
    destination "#{path}/source"
    user new_resource.user
    group new_resource.group
  end

  bash "#{new_resource.name}: npm install" do
    user new_resource.user
    cwd "#{path}/source"
    code <<-EOH
      npm install
    EOH
    only_if new_resource.install_deps
  end

  pm2_application new_resource.name do
    script new_resource.script
    cwd "#{path}/source"
    node_args new_resource.node_args
    action [:deploy, :start_or_restart]
  end

  new_resource.updated_by_last_action(true)
end
