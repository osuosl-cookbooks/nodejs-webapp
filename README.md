nodejs-webapp
=============

A cookbook for easily deploying webapps like TimeSync and Etherpad-Lite.

Supported platforms
-------------------

Currently, nodejs-webapp is tested on the following:

* CentOS 6.6
* CentOS 7.1

However, there's a good chance it works on Debian-based operating systems as
well.

Usage
-----

Apps can be deployed like so:

```
nodejs_webapp 'my_node_app' do
  script 'app.js'
  repository 'https://github.com/osuosl/my_node_app.git'
  node_args ['--harmony']
end
```

Option            | Type      | Required? | Default value
------------------|-----------|-----------|--------------
`:repository`     | String    | ✓         |
`:branch`         | String    | ✓         |
`:script`         | String    | ✓         |
`:node_args`      | Array     |           | [ ]
`:install_deps`   | Boolean   |           | `true`
`:path`           | String    |           | `/opt/:app_name`
`:user`           | String    |           | `root`
`:group`          | String    |           | `root`
`:create_user`    | Boolean   |           | `false`

* ``node_args``: arguments to pass to Node when running the app. For
  ``--harmony``, set ``node_args: ['--harmony']``.
* ``path``: where the app should live on the server. Defaults to the resource's
  name inside of `/opt`. For example, the block above would live in
  `/opt/my_node_app`.
* ``user``, ``group``, and ``create_user``: the user and group to run Node as.
  This user will also own the source code. If this user doesn't exist, it can
  be automatically created by setting ``create_user`` to ``True``.

Notes
-----

This app will be run with whatever version of Node is first in the system's
``PATH``. If Node isn't installed, it will be installed; to control the version
that's installed, see the [NodeJS cookbook documentation](https://github.com/redguide/nodejs).

**pm2 configuration**: If you specify a user account for your app, ``pm2`` will
store the information about that application under that user account. To view
information about the process, first ``su`` to the proper account before running
``pm2 list``.

Running tests
-------------

To run all tests, including style checks with both foodcritic and rubocop, we
use Rake. Rake allows for a granular level of testing, including running
integration, style, and unit testing from one tool.

To run all tests using a Vagrant virtual machine, run:

    $ rake

If you have access to an Openstack environment, you can set up your environment
variables to allow you to run integration tests on Openstack. Setting that up is
beyond the scope of this guide; if you're already set up, you can run style and
unit tests locally and integration tests on Openstack with:

    $ rake cloud


Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `username/add_component_x`)
3. Write tests for your change
4. Write your change
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
- Author:: Oregon State University <chef@osuosl.org>

```text
Copyright 2015 Oregon State University

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
