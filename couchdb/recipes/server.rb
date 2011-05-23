include_recipe "couchdb::prepare"

couchdb_installed_version = `which couchdb > /dev/null && couchdb -V | grep #{node[:couchdb][:version]}`.strip.gsub(/^.+([0-9.]{5,5})$/, '\1')

couchdb_already_installed = lambda do
  couchdb_installed_version == node[:couchdb][:version]
end

remote_file "/tmp/apache-couchdb-#{node[:couchdb][:version]}.tgz" do
  source "http://apache.easy-webs.de/couchdb/#{node[:couchdb][:version]}/apache-couchdb-#{node[:couchdb][:version]}.tar.gz"
  not_if &couchdb_already_installed
end

execute "unpack CouchDB" do
  command "cd /tmp && tar -xzf apache-couchdb-#{node[:couchdb][:version]}.tgz"
  not_if &couchdb_already_installed
end

execute "Configure CouchDB" do
  cwd "/tmp/apache-couchdb-#{node[:couchdb][:version]}"
  environment "HOME" => "/root"
  command "./configure --sysconfdir=/etc"
  not_if &couchdb_already_installed
end

execute "Compile and install CouchDB" do
  cwd "/tmp/apache-couchdb-#{node[:couchdb][:version]}"
  environment "HOME" => "/root"
  command "make && make install"
  not_if &couchdb_already_installed
end


template "/etc/couchdb/local.d/scalarium.ini" do
  source "scalarium.ini.erb"
  owner "couchdb"
  group "couchdb"
  mode "0644"
end

if node[:couchdb][:port] == 80
  execute "Running on port 80, we require root" do
    command "sed -i 's,COUCHDB_USER=couchdb,COUCHDB_USER=root,g' /etc/default/couchdb"
  end
end

service "couchdb" do
  service_name "couchdb"
  supports [:start, :status, :restart]
  action :start
  not_if "which couchdb > /dev/null && couchdb -s"
end

template "/etc/logrotate.d/couchdb" do
  source "logrotate.erb"
  mode "0644"
  owner "root"
  group "root"
end

if node[:couchdb][:backup]
  template "/usr/local/bin/couchdb_backup" do
    source "couchdb_backup.erb"
    mode "0755"
    owner "root"
    group "root"
  end

  template "/usr/local/bin/couchdb_clean_backups" do
    source "couchdb_clean_backups.erb"
    mode "0755"
    owner "root"
    group "root"
  end

  directory node[:couchdb][:backupdir] do
    mode "0755"
    owner "root"
    owner "root"
    recursive true
  end

  execute "set owner on couchdb backup directory" do
    command "chown -R couchdb:couchdb #{node[:couchdb][:backupdir]}"
  end

  cron "backup couchdb files" do
    hour "0-23/4"
    minute "0"
    command "/usr/local/bin/couchdb_backup"
    user "couchdb"
    path "/usr/bin:/usr/local/bin:/bin:/sbin:/usr/sbin"
  end
end

if node[:couchdb][:replica]
  http_request nil do
    action :post
    url "http://localhost:5984/_replicate"
    message({
      "source" => "http://#{node[:scalarium][:datastore_dns]}:5984/scalarium",
      "target" => "scalarium",
      "continuous" => true,
      "create_target" => true
    })
  end
end
