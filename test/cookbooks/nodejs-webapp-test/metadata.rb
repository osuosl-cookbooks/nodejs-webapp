name 'nodejs-webapp-test'
maintainer 'Oregon State University'
maintainer_email 'chef@osuosl.org'
license 'Apache 2.0'
description 'Used to test the nodejs-webapp cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.0.1'

depends 'build-essential'
depends 'git'
depends 'pm2'
depends 'nodejs'
depends 'magic_shell'
depends 'nodejs-webapp'
