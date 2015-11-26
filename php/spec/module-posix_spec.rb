require_relative 'spec_helper.rb'

describe 'php::module-posix' do

  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end

  it 'adds ppa mirror configuration' do
    expect(chef_run).to include_recipe('apt::ppa')
    expect(chef_run).to include_recipe('apt::easybib')
  end

  it 'installs and configures the extension' do
    expect(chef_run).to install_php_ppa_package('posix')
  end

end