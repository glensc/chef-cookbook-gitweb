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

# Gitweb configuration
package "gitweb" do
  action :install
end

template "/etc/gitweb.conf" do
  owner  "root"
  group  "root"
  mode   "0644"
  variables(:gitweb => node[:gitweb])
  notifies :reload, resources(:service => "apache2")
end

gitweb_htpasswd = "/etc/gitweb.htpasswd"
if node[:gitweb][:users]
  node[:gitweb][:users].each do |user_name|
    htpasswd gitweb_htpasswd do
      user user_name
      password data_bag_item('users', user_name)['password']
    end
  end
end

# Gitweb Apache site
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
  gitweb node[:gitweb]
  if node[:gitweb][:users]
    htpasswd gitweb_htpasswd
  end
  notifies :reload, resources(:service => "apache2")
end

# Disabling Apache default site
apache_site "default" do
  enable false
end

# Gitweb theme
if node[:gitweb][:theme]
  git "/usr/share/gitweb/theme" do
    repository node[:gitweb][:theme]
    reference "master"
    action :sync
  end
end

# Nginx
if node[:gitweb][:nginx_proxy]
    include_recipe "nginx"

    template "/etc/nginx/sites-available/gitweb" do
      source "nginx.conf.erb"
      owner  "root"
      group  "root"
      mode   "0644"
      variables(
        :server_port => node[:gitweb][:nginx_port],
        :gitweb => node[:gitweb]
      )
      notifies :restart, resources(:service => "nginx")
    end

    nginx_site "gitweb"
end
