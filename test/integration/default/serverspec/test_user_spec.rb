require 'serverspec'
set :backend, :exec

describe group('test_a') do
  it { should exist }
end

describe user('test_a') do
  it { should exist }
  it { should belong_to_group 'test_a' }
end
