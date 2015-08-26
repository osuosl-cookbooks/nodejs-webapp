require 'serverspec'
set :backend, :exec

describe command('cat /etc/profile.d/PATH.sh') do
  its(:stdout) { should contain '/usr/local/bin' }
end
