require 'serverspec'
set :backend, :exec

# test b
describe port(8888) do
  it { should be_listening }
end

# test a
describe port(3000) do
  it { should be_listening }
end
