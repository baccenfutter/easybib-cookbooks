include_recipe 'ies-apt::ppa'

apt_repository 'easybib-couchdb-ppa' do
  uri           ::EasyBib::Ppa.ppa_mirror(node, node['apache-couchdb']['ppa'])
  distribution  node['lsb']['codename']
  components    ['main']
end

package 'couchdb'

include_recipe 'apache-couchdb::configure'
