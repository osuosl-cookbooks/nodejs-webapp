require 'chefspec'
require 'spec_helper'

describe 'nodejs-webapp-test::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      step_into: ['nodejs-webapp']).converge(described_recipe)
  end

  it 'creates user and group for test_a' do
    expect(chef_run).to create_group('test_a')
    expect(chef_run).to create_user('test_a')
  end

  it 'creates directory for test_a' do
    expect(chef_run).to create_directory('/opt/custom')
  end

  it 'checks out test_a and test_b' do
    expect(chef_run).to sync_git('/opt/custom').with(
      repository: 'https://github.com/osuosl/nodejs-test-apps.git',
      branch: 'custom')
    expect(chef_run).to sync_git('/opt/test_b').with(
      repository: 'https://github.com/osuosl/nodejs-test-apps.git')
  end

  it 'installs dependencies for test_a with npm' do
    expect(chef_run).to run_bash('test_a: npm install').with(
      cwd: '/opt/custom/source')
  end

  it 'should not install dependencies for test_b with npm' do
    expect(chef_run).not_to run_bash('test_b: npm install').with(
      cwd: '/opt/test_b')
  end

  it 'should start or restart app script run.js with pm2' do
    expect(chef_run).to start_or_reload_pm2_application('test_a').with(
      script: 'run.js',
      user: 'test_a',
      node_args: %w(--harmony --no-deprecation))
  end
end
