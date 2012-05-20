Description
===========

[Gitweb](https://git.wiki.kernel.org/index.php/Gitweb) installation and configuration.
Easily can be used with [chef-gitolite](https://github.com/rocketlabsdev/chef-gitolite).

Gitweb user and group can be specified ([apache2-mpm-itk](http://mpm-itk.sesse.net) used).

Attributes
==========

See `attributes/default.rb`.

Usage
=====

Example node configuration:

    {
      "gitolite": [{"name": "git", "admin": "user"}],
      "gitweb": {
        "server_name": "git.domain.com",
        "user": "git",
        "group": "www-data"
      },
      "run_list": [
        "recipe[gitolite]",
        "recipe[gitweb]"
      ]
    }