require 'serverspec'
set :backend, :exec

# Test that the tmp folder has been cleared of unnecessary files
describe command('ls /tmp | grep "npm-"') do
  its(:stdout) { should match '' }
  its(:exit_status) { should eq 1 } # 1 = no lines match
end
