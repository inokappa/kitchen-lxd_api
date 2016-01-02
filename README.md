# Kitchen::Driver::LxdApi
[![Build Status](https://travis-ci.org/inokappa/kitchen-lxd_api.svg)](https://travis-ci.org/inokappa/kitchen-lxd_api)

A Test Kitchen Driver for LXD REST API.

## Reference

- [LXD REST API](https://github.com/lxc/lxd/blob/master/specs/rest-api.md)
- [bradenwright/kitchen-lxd_cli](https://github.com/bradenwright/kitchen-lxd_cli)

## Requirements

- [LXD](https://linuxcontainers.org/)
- [puppetlabs/net_http_unix](https://github.com/puppetlabs/net_http_unix)
- [Oreno LXD REST API Client](https://github.com/inokappa/oreno_lxdapi)

## Installation and Setup

### Install kitchen driver

```sh
$ git clone https://github.com/inokappa/kitchen-lxd_api.git
$ cd kitchen-lxd_api
$ bundle install
```

## Configuration

### Create Container image

```sh
$ lxc remote add images images.linuxcontainers.org
$ lxc launch images:ubuntu/trusty/amd64 oreno-ubuntu
$ lxc exec oreno-ubuntu -- apt-get -y install openssh-server
$ lxc stop oreno-ubuntu
$ lxc publish oreno-ubuntu --alias=oreno-ubuntu-image
```

### .kitchen.yml

```yaml
---
driver:
  name: lxd_api

provisioner:
  name: ansible_playbook
  roles_path: roles
  # require_chef_for_busser: false
  # require_ruby_for_busser: true

platforms:
  - name: oreno-ubuntu-14.04
    driver_plugin: lxd_api
    driver_config:
      container_image: oreno-ubuntu-image
      container_name: kitchen-container
      #
      # Optional
      #
      # username: kitchen
      # architecture: 2
      # profiles: ["default"]
      # ephemeral: false
      # limits_cpu: "1"
      # timeout: 30
      # force: true

suites:
  - name: default
    provisioner:
      playbook: default.yml
      hosts: default

verifier:
  name: shell
  command: rspec -c -f d -I serverspec serverspec/common_spec.rb

```

## Let's tasting...

```sh
$ kitchen create
$ kitchen converge
$ kitchen verify
$ kitchen destroy
```

## Development

* Source hosted at [GitHub][repo]
* Report issues/questions/feature requests on [GitHub Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make. For
example:

1. Fork the repo
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authors

Created and maintained by inokappa

## License

Apache 2.0 (see [LICENSE][license])


[author]:           https://github.com/enter-github-user
[issues]:           https://github.com/enter-github-user/kitchen-lxd_api/issues
[license]:          https://github.com/enter-github-user/kitchen-lxd_api/blob/master/LICENSE
[repo]:             https://github.com/enter-github-user/kitchen-lxd_api
[driver_usage]:     http://docs.kitchen-ci.org/drivers/usage
[chef_omnibus_dl]:  http://www.getchef.com/chef/install/
