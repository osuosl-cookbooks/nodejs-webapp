#
# Cookbook Name:: nodejs-webapp
# Resource:: default
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

default_action :install

# The information necessary to check out the code
attribute :repository, 'kind_of' => String
attribute :branch, 'kind_of' => String, :default => 'master'
attribute :script, 'kind_of' => String

attribute :node_args, 'kind_of' => [Array, NilClass], :default => nil
attribute :install_deps, 'kind_of' => [TrueClass, FalseClass], :default => true

# Create the owner, path, or group if they do not exist
# If path is nil it will default to '/opt/<name_attribute>'
attribute :path, 'kind_of' => [String, NilClass], :default => nil
attribute :user, 'kind_of' => String, :default => 'root'
attribute :group, 'kind_of' => String, :default => 'root'

attribute :env, 'kind_of' => [Hash, NilClass], :default => nil
