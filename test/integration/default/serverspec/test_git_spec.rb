require 'serverspec'
set :backend, :exec

# Test that the git repository's directory is properly set up
describe file('/opt/custom/source') do
  it { should be_directory }
  it { should be_grouped_into 'root' }
  it { should be_owned_by 'root' }
end

# Test that the git repository is actually a git repository
describe file('/opt/custom/source/.git') do
  it { should be_directory }
  it { should be_grouped_into 'root' }
  it { should be_owned_by 'root' }
end

# Test that the right revision has been checked out
describe command('cd /opt/custom/source/ && '\
  'diff <(git rev-parse HEAD) <(git rev-parse origin/custom)') do
  its(:stdout) { should match '' }
end

# Test that the git repository's directory is properly set up
describe file('/opt/test_b/') do
  it { should be_directory }
  it { should be_grouped_into 'root' }
  it { should be_owned_by 'root' }
end

# Test that the git repository is actually a git repository
describe file('/opt/test_b/source/.git') do
  it { should be_directory }
  it { should be_grouped_into 'root' }
  it { should be_owned_by 'root' }
end

# Test that the right revision has been checked out
describe command('cd /opt/test_b/source/ && '\
  'diff <(git rev-parse HEAD) <(git rev-parse origin/master)') do
  its(:stdout) { should match '' }
end
