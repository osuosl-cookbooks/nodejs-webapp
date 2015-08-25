require 'serverspec'
set :backend, :exec

describe group('custom') do
  it { should exist }
end

describe user('custom') do
  it { should exist }
end

describe user('custom') do
  it { should belong_to_group 'custom' }
end
