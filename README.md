Description
===========

[Gitweb](https://git.wiki.kernel.org/index.php/Gitweb) installation and configuration.
Easily can be used with [chef-gitolite](https://github.com/nickola/chef-gitolite) cookbook.

Features:

 - [Nginx](http://www.nginx.org) as web server.

 - [Nginx](http://www.nginx.org) HTTPS (SSL) configuration supported (self-signed certificate can be generated automatically).

 - [Nginx](http://www.nginx.org) automatically HTTP to HTTPS redirect configuration supported.

 - Theme [gitweb-theme](https://github.com/kogakure/gitweb-theme) applied by default.

 - User/password protection supported.

 - "git clone" over HTTP/HTTPS enabled, this will work:

        git clone https://git.domain.com/repository.git

        or with user/password protection:

        git clone https://user@password:git.domain.com/repository.git

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

Node configuration example with user/password protection:

    {
      "gitolite": {
        "git": {"admin": "user1"}
      },
      "gitweb": {
        "server_name": "git.domain.com",
        "users": ["user1", "user2"]
      },
      "run_list": [
        "recipe[gitolite]",
        "recipe[gitweb]"
      ]
    }

Node configuration example with user/password protection and HTTPS (SSL):

    {
      "gitolite": {
        "git": {"admin": "user1"}
      },
      "gitweb": {
        "nginx_port": 443,
        "nginx_ssl": "self-signed",
        "server_name": "git.domain.com",
        "users": ["user1", "user2"]
      },
      "run_list": [
        "recipe[gitolite]",
        "recipe[gitweb]"
      ]
    }

Users data bag example (compatible with Chef [users cookbook](https://github.com/opscode-cookbooks/users)):

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
