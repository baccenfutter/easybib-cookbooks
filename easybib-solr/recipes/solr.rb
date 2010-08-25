include_recipe "easybib-solr::raid"

ebs_vol=#node["solr"]["working_directory"]

subversion "Checkout: Research Importers" do
  repository "#{node["solr"]["deploy_svn"]}/research_importers/#{node["solr"]["research_version"}"
  destination "#{ebs_vol}/research_importers"
  action :sync
end

subversion "Checkout: Solr" do
  repository "#{node["solr"]["deploy_svn"]}/solr/#{node["solr"]["solr_svn_version"}"
  destination "#{ebs_vol}/apache-solr-#{node["solr"]["solr_version"}-compiled"
  action :sync    
end

link "#{ebs_vol}/research_importers/etc/solr.conf" do
  to "/etc/solr.conf"
end

link "#{ebs_vol}/research_importers/scripts/solr.sh" do
  to "/etc/init.d/solr"
end

service "solr" do
  service_name "solr"
  supports [:start, :status, :restart, :stop]
  action :enable
end