require 'serverspec'
set :backend, :exec

# Test that the git repository's directory is properly set up
describe command('ls /tmp | grep "npm-"') do
  its(:stdout) { should match '' }
  its(:exit_status) { should eq 0 }
end
