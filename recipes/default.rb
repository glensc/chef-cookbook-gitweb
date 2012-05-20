# Apache
include_recipe "apache2"
include_recipe "apache2::mod_fcgid"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_deflate"

# Apache "mpm-itk"
if node['gitweb']['owner'] and node['gitweb']['group']
  package "apache2-mpm-itk" do
    action :install
  end
end

# Gitweb
package "gitweb" do
  action :install
end

template "/etc/gitweb.conf" do
  owner  "root"
  group  "root"
  mode   "0644"
  variables(
    :server_name => node[:gitweb][:server_name],
    :gitweb_theme => node[:gitweb][:theme],
    :gitweb_project_root => node[:gitweb][:project_root],
    :gitweb_base_url_list => node[:gitweb][:base_url_list]
  )
end

gitweb_server_aliases = node[:gitweb][:server_aliases]
if not gitweb_server_aliases
    gitweb_server_aliases = [node[:gitweb][:server_name]]
end
web_app "gitweb" do
  template "apache.conf.erb"
  # Apache settings
  server_port node[:gitweb][:server_port]
  server_name node[:gitweb][:server_name]
  server_aliases gitweb_server_aliases
  docroot node[:gitweb][:document_root]
  # Gitweb settings
  gitweb_owner node[:gitweb][:owner]
  gitweb_group node[:gitweb][:group]
  gitweb_config node[:gitweb][:config]
  gitweb_project_root node[:gitweb][:project_root]
end

# Gitweb theme
if node['gitweb']['theme']
  git "/usr/share/gitweb/theme" do
    repository node['gitweb']['theme']
    reference "master"
    action :sync
  end
end