name             'nodejs-webapp'
maintainer       'Oregon State University'
maintainer_email 'chef@osuosl.org'
license          'apache2'
description      'Installs/Configures nodejs-webapp'
long_description 'Installs/Configures nodejs-webapp'
version          '1.0.1'
issues_url       'https://github.com/osuosl-cookbooks/nodejs-webapp/issues'
source_url       'https://github.com/osuosl-cookbooks/nodejs-webapp'

depends 'build-essential'
depends 'git'
depends 'magic_shell'
depends 'nodejs'
depends 'pm2'

supports         'centos', '~> 6.0'
supports         'centos', '~> 7.0'
