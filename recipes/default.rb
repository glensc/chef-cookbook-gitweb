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
gitweb_conf = "/etc/gitweb"
gitweb_htpasswd = "#{gitweb_conf}/gitweb.htpasswd"

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

if node[:gitweb][:users]
  directory gitweb_conf do
    owner "root"
    group "root"
    mode "0755"
    action :create
  end

  node[:gitweb][:users].each do |user_name|
    if !::File.exists?(gitweb_htpasswd) || File.read(gitweb_htpasswd).grep(/^#{Regexp.escape(user_name)}/).empty?
      htpasswd gitweb_htpasswd do
        user user_name
        password data_bag_item('users', user_name)['password']
        notifies :reload, resources(:service => "apache2")
      end
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
  not_if { node['apache']['default_site_enabled'] }
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

  ssl_certificate = nil
  if node[:gitweb][:nginx_ssl] == "self-signed"
    ssl_certificate = "#{gitweb_conf}/ssl.pem"

    directory gitweb_conf do
      owner "root"
      group "root"
      mode "0755"
      action :create
    end

    execute "make self-signed SSL certificate" do
      user "root"
      group "www-data"
      umask "0127"
      command "openssl req -x509 -nodes -days #{node[:gitweb][:nginx_ssl_days]} -newkey #{node[:gitweb][:nginx_ssl_key_type]}:#{node[:gitweb][:nginx_ssl_key_size]} -subj '/CN=#{node[:gitweb][:server_name]}' -keyout #{ssl_certificate} -out #{ssl_certificate}"
      notifies :restart, resources(:service => "nginx")
      creates ssl_certificate
    end
  end

  template "/etc/nginx/sites-available/gitweb" do
    source "nginx.conf.erb"
    owner  "root"
    group  "root"
    mode   "0644"
    variables(
      :server_host => node[:gitweb][:nginx_host],
      :server_port => node[:gitweb][:nginx_port],
      :server_name => node[:gitweb][:server_name],
      :ssl_certificate => ssl_certificate,
      :http_to_https => node[:gitweb][:nginx_http_to_https],
      :root => node[:gitweb][:document_root],
      :gitweb => node[:gitweb]
    )
    notifies :restart, resources(:service => "nginx")
  end

  nginx_site "gitweb"
end
