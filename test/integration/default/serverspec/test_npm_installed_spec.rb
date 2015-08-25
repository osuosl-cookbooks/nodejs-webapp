require 'serverspec'
set :backend, :exec

# Test that express was properly installed into node_modules
describe file('/opt/custom/source/node_modules/express') do
  it { should be_directory }
  it { should be_grouped_into 'test_a' }
  it { should be_owned_by('test_a') }
end
