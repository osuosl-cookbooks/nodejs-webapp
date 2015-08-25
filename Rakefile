#
# Cookbook Name:: nodejs-webapp
#
# Copyright Chef, Oregon State University
#
# Original authors: https://github.com/chef-cookbooks/yum/blob/master/Rakefile
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

# Rake tasks

require 'rake'

require 'fileutils'
require 'base64'
require 'chef/encrypted_data_bag_item'
require 'json'
require 'openssl'

require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'foodcritic'
require 'kitchen'

# Style tests. Rubocop and Foodcritic
namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      fail_tags: ['any']
    }
  end
end

desc 'Run all style checks'
task style: %w(style:chef style:ruby)

# Rspec and ChefSpec
desc 'Run ChefSpec tests'
RSpec::Core::RakeTask.new(:spec)

# Integration tests. Kitchen.ci
namespace :integration do
  desc 'Run Test Kitchen with Vagrant'
  task :vagrant do
    Kitchen.logger = Kitchen.default_file_logger
    Kitchen::Config.new.instances.each do |instance|
      instance.test(:always)
    end
  end

  desc 'Run Test Kitchen with cloud plugins'
  task :cloud do
    Kitchen.logger = Kitchen.default_file_logger
    @loader = Kitchen::Loader::YAML.new(project_config: './.kitchen.cloud.yml')
    config = Kitchen::Config.new(loader: @loader)
    config.instances.each do |instance|
      instance.test(:always)
    end
  end
end

desc 'Run all tests (style, spec, integration) on Openstack'
task cloud: %w(style spec integration:cloud)

desc 'Run all tests (style, spec, integration) on Vagrant'
task vagrant: %w(style spec integration:vagrant)

desc 'Run style and spec tests (for Travis)'
task travis: %w(style spec)

# Default
task default: %w(style spec integration:vagrant)

snakeoil_file_path = 'test/integration/data_bags/certificates/snakeoil.json'
encrypted_data_bag_secret_path = 'test/integration/encrypted_data_bag_secret'

##
# Create a self-signed SSL certificate
#
def gen_ssl_cert
  name = OpenSSL::X509::Name.new [
    ['C', 'US'],
    ['ST', 'Oregon'],
    ['CN', 'OSU Open Source Lab'],
    ['DC', 'example']
  ]
  key = OpenSSL::PKey::RSA.new 2048

  cert = OpenSSL::X509::Certificate.new
  cert.version = 2
  cert.serial = 2
  cert.subject = name
  cert.public_key = key.public_key
  cert.not_before = Time.now
  cert.not_after = cert.not_before + 1 * 365 * 24 * 60 * 60 # 1 years validity

  # Self-sign the Certificate
  cert.issuer = name
  cert.sign(key, OpenSSL::Digest::SHA1.new)

  return cert, key
end

##
# Create a data bag item (with the id of snakeoil) containing a self-signed SSL
#  certificate
#
def ssl_data_bag_item
  cert, key = gen_ssl_cert
  Chef::DataBagItem.from_hash(
    'id' => 'snakeoil',
    'cert' => cert.to_pem,
    'key' => key.to_pem
  )
end

##
# Create the integration tests directory if it doesn't exist
#
directory 'test/integration'

##
# Generates a 512 byte random sequence and write it to
#  'test/integration/encrypted_data_bag_secret'
#
file encrypted_data_bag_secret_path => 'test/integration' do
  encrypted_data_bag_secret = OpenSSL::Random.random_bytes(512)
  open encrypted_data_bag_secret_path, 'w' do |io|
    io.write Base64.encode64(encrypted_data_bag_secret)
  end
end

##
# Create the certificates data bag if it doesn't exist
#
directory 'test/integration/data_bags/certificates' => 'test/integration'

##
# Create the encrypted snakeoil certificate under
#  test/integration/data_bags/certificates
#
file snakeoil_file_path => [
  'test/integration/data_bags/certificates',
  'test/integration/encrypted_data_bag_secret'
] do

  encrypted_data_bag_secret = Chef::EncryptedDataBagItem.load_secret(
    encrypted_data_bag_secret_path
  )

  encrypted_snakeoil_cert = Chef::EncryptedDataBagItem.encrypt_data_bag_item(
    ssl_data_bag_item, encrypted_data_bag_secret
  )

  open snakeoil_file_path, 'w' do |io|
    io.write JSON.pretty_generate(encrypted_snakeoil_cert)
  end
end

desc 'Create an Encrypted Databag Snakeoil SSL Certificate'
task snakeoil: snakeoil_file_path

desc 'Create an Encrypted Databag Secret'
task secret_file: encrypted_data_bag_secret_path
