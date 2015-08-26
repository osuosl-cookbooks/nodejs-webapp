require 'serverspec'
set :backend, :exec

# Test that express was properly installed into node_modules
describe file('/opt/custom/source/node_modules/express') do
  it { should be_directory }
  it { should be_grouped_into 'root' }
  it { should be_owned_by 'root' }
end
