maintainer        "Nickolay Kovalev"
maintainer_email  "nickola@nickola.ru"
license           "Apache 2.0"
description       "Gitweb installation and configuration"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.0"

%w{debian ubuntu}.each do |os|
  supports os
end
