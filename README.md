Description
===========

[Gitweb](https://git.wiki.kernel.org/index.php/Gitweb) installation and configuration.
Easily can be used with [chef-gitolite](https://github.com/nickola/chef-gitolite) cookbook.

Features:

 - Gitweb owner and group can be specified ([apache2-mpm-itk](http://mpm-itk.sesse.net) used).

 - Theme [gitweb-theme](https://github.com/kogakure/gitweb-theme) applied by default.

 - User/password protection supported.

 - [Nginx](http://www.nginx.org) as proxy supported.

 - "git clone" over HTTP enabled, this will work:

        git clone http://git.domain.com/repository.git

Attributes
==========

See `attributes/default.rb` for default values.

Usage
=====

Node configuration example:

    {
      "gitolite": {
        "git": {"admin": "user1"}
      },
      "gitweb": {
        "server_name": "git.domain.com"
      },
      "run_list": [
        "recipe[gitolite]",
        "recipe[gitweb]"
      ]
    }

Node configuration example with user/password protection and nginx as proxy:

    {
      "apache": {"listen_ports": ["8080"]},
      "gitolite": {
        "git": {"admin": "user1"}
      },
      "gitweb": {
        "nginx_proxy": true,
        "server_port": "8080",
        "server_name": "git.domain.com",
        "users": ["user1", "user2"]
      },
      "run_list": [
        "recipe[gitolite]",
        "recipe[gitweb]"
      ]
    }

Users data bag example (compatible with with Chef [users cookbook](https://github.com/opscode-cookbooks/users)):

    knife data bag users user1
    {
      "id": "user1",
      "password": "user1_password",
      "ssh_keys": "ssh-rsa AAAAB3Nz...yhCw== user1"
    }

    knife data bag users user2
    {
      "id": "user2",
      "password": "user2_password"
    }
