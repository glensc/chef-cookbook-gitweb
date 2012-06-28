# Base settings
default[:gitweb][:group] = "www-data"
default[:gitweb][:config] = "/etc/gitweb.conf"
default[:gitweb][:config_directory] = "/etc/gitweb"
default[:gitweb][:project_root] = "/home/git/repositories"
default[:gitweb][:base_url_list] = []
default[:gitweb][:server_name] = "git.#{node[:domain]}"
default[:gitweb][:server_root] = "/usr/share/gitweb"

# Nginx settings
default[:gitweb][:nginx_host] = nil
default[:gitweb][:nginx_port] = 80
default[:gitweb][:nginx_http_to_https] = true
default[:gitweb][:nginx_default_server] = false
default[:gitweb][:nginx_ssl] = false
default[:gitweb][:nginx_ssl_days] = 365 * 5
default[:gitweb][:nginx_ssl_key_type] = "rsa"
default[:gitweb][:nginx_ssl_key_size] = 2048

# Theme settings
default[:gitweb][:theme] = "https://github.com/kogakure/gitweb-theme.git"
