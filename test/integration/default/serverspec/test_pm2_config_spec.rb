require 'serverspec'
set :backend, :exec

describe file('/etc/pm2/conf.d/test_a.json') do
  its(:content) { should contain '--harmony' }
  its(:content) { should contain '--no-deprecation' }
end

describe file('/etc/pm2/conf.d/test_a.json') do
  its(:content) { should contain 'run.js' }
end

describe file('/etc/pm2/conf.d/test_a.json') do
  its(:content) { should contain '/opt/custom/source' }
end

describe file('/etc/pm2/conf.d/test_b.json') do
  its(:content) { should contain 'run.js' }
end

describe file('/etc/pm2/conf.d/test_b.json') do
  its(:content) { should contain '/opt/test_b/source' }
end
