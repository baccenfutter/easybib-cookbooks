require_relative 'spec_helper.rb'

describe 'stack-citationapi::role-publicapi' do

  let(:runner)   { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  before do
    node.set['opsworks']['stack']['name'] = 'Stack'
    node.set['opsworks']['instance']['layers'] = ['bibapi']
    node.set['opsworks']['instance']['hostname'] = 'host'
    node.set['opsworks']['instance']['ip'] = '127.0.0.1'
    node.set['deploy']['easybib_api'] = {
      :deploy_to => '/srv/www/bibapi',
      :document_root => 'public'
    }
  end

  it 'referes to the new recipe' do
    expect(chef_run).to include_recipe('stack-citationapi::role-formatting-api')
  end

end