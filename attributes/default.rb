# Base settings
default[:gitweb][:group] = "www-data"
default[:gitweb][:config] = "/etc/gitweb.conf"
default[:gitweb][:config_directory] = "/etc/gitweb"
default[:gitweb][:project_root] = "/home/git/repositories"
default[:gitweb][:base_url_list] = []

# Nginx settings
default[:gitweb][:server_host] = nil
default[:gitweb][:server_port] = 80
default[:gitweb][:server_name] = "git.#{node[:domain]}"
default[:gitweb][:server_root] = "/usr/share/gitweb"
default[:gitweb][:server_http_to_https] = false
default[:gitweb][:ssl] = false
default[:gitweb][:ssl_days] = 365 * 5
default[:gitweb][:ssl_key_type] = "rsa"
default[:gitweb][:ssl_key_size] = 2048

# Theme settings
default[:gitweb][:theme] = "https://github.com/kogakure/gitweb-theme.git"
