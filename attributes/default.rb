# Base settings
default[:gitweb][:owner] = "git"
default[:gitweb][:group] = "www-data"
default[:gitweb][:config] = "/etc/gitweb.conf"
default[:gitweb][:project_root] = "/home/git/repositories"
default[:gitweb][:base_url_list] = []

# Apache settings
default[:gitweb][:server_port] = 80
default[:gitweb][:server_name] = "git.#{node[:domain]}"
default[:gitweb][:server_aliases] = nil
default[:gitweb][:document_root] = "/usr/share/gitweb"

# Nginx settings
default[:gitweb][:nginx_proxy] = false
default[:gitweb][:nginx_host] = nil
default[:gitweb][:nginx_port] = 80
default[:gitweb][:nginx_ssl] = false
default[:gitweb][:nginx_ssl_days] = 365 * 5
default[:gitweb][:nginx_ssl_key_type] = "rsa"
default[:gitweb][:nginx_ssl_key_size] = 2048

# Theme settings
default[:gitweb][:theme] = "https://github.com/kogakure/gitweb-theme.git"
