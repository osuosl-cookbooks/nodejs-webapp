require 'chefspec'
require 'spec_helper'

describe 'nodejs-webapp-test::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      step_into: ['nodejs-webapp']
    ).converge(described_recipe)
  end

  it 'runs app test_run' do
    expect(chef_run).to run_nodejs_webapp('test_run')
  end

  it 'should start or restart app script run.js with pm2' do
    expect(chef_run).to start_pm2_application('test_run').with(
      script: 'run.js',
      user: 'test_run',
      node_args: %w(--harmony --no-deprecation)
    )
  end
end
