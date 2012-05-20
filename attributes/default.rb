default.gitweb[:owner] = "git"
default.gitweb[:group] = "www-data"
default.gitweb[:project_root] = "/home/git/repositories"
default.gitweb[:config] = "/etc/gitweb.conf"
default.gitweb[:base_url_list] = []
# Apache
default.gitweb[:server_port] = 80
default.gitweb[:server_name] = "git.#{node[:domain]}"
default.gitweb[:server_aliases] = nil
default.gitweb[:document_root] = "/usr/share/gitweb"
# Theme
default.gitweb[:theme] = "https://github.com/kogakure/gitweb-theme.git"