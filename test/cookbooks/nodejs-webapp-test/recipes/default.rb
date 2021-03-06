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

#
# Cookbook Name:: osl_application_python_test
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

nodejs_webapp 'test_a' do
  path '/opt/custom'
  user 'test_a'
  group 'test_a'

  script 'run.js'
  repository 'https://github.com/osuosl/nodejs-test-apps.git'
  branch 'custom'

  node_args ['--harmony', '--no-deprecation']
end

nodejs_webapp 'test_b' do
  script 'run.js'
  repository 'https://github.com/osuosl/nodejs-test-apps.git'
  install_deps false
  branch 'master'
end
