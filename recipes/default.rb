include_recipe "nginx"

# Packages
["gitweb", "fcgiwrap"].each do |package_name|
  package package_name do
    action :install
  end
end

# Gitweb configuration
htpasswd_file = nil

template node[:gitweb][:config] do
  owner  "root"
  group  "root"
  mode   "0644"
  variables(:gitweb => node[:gitweb])
  notifies :reload, resources(:service => "nginx")
end

if node[:gitweb][:users]
  htpasswd_file = "#{node[:gitweb][:config_directory]}/.htpasswd"

  directory node[:gitweb][:config_directory] do
    owner "root"
    group "root"
    mode "0755"
    action :create
  end

  node[:gitweb][:users].each do |user_name|
    if !::File.exists?(htpasswd_file) || File.read(htpasswd_file).grep(/^#{Regexp.escape(user_name)}/).empty?
      htpasswd htpasswd_file do
        user user_name
        password data_bag_item('users', user_name)['password']
        notifies :reload, resources(:service => "nginx")
      end
    end
  end
end

# Gitweb theme
if node[:gitweb][:theme]
  git "#{node[:gitweb][:server_root]}/theme" do
    repository node[:gitweb][:theme]
    reference "master"
    action :sync
  end
end

# Nginx
ssl_file = nil
if node[:gitweb][:ssl] && node[:gitweb][:ssl] == "self-signed"
  ssl_file = "#{node[:gitweb][:config_directory]}/ssl.pem"

  directory node[:gitweb][:config_directory] do
    owner "root"
    group "root"
    mode "0755"
    action :create
  end

  execute "make self-signed SSL certificate" do
    user "root"
    group node[:gitweb][:group]
    umask "0127"
    command "openssl req -x509 -nodes -days #{node[:gitweb][:ssl_days]} -newkey #{node[:gitweb][:ssl_key_type]}:#{node[:gitweb][:ssl_key_size]} -subj '/CN=#{node[:gitweb][:server_name]}' -keyout #{ssl_file} -out #{ssl_file}"
    notifies :restart, resources(:service => "nginx")
    creates ssl_file
  end
end

template "/etc/nginx/sites-available/gitweb" do
  source "nginx.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  variables(
    :server_host => node[:gitweb][:server_host],
    :server_port => node[:gitweb][:server_port],
    :server_name => node[:gitweb][:server_name],
    :server_root => node[:gitweb][:server_root],
    :http_to_https => node[:gitweb][:server_http_to_https],
    :htpasswd => htpasswd_file,
    :ssl => ssl_file,
    :gitweb => node[:gitweb]
  )
  notifies :restart, resources(:service => "nginx")
end

nginx_site "gitweb"
