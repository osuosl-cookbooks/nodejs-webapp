require 'serverspec'
set :backend, :exec

describe command('echo $PATH') do
  its(:stdout) { should contain '/usr/local/bin/' }
end
