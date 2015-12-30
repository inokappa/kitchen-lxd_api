# Kitchen::Driver::LxdApi

A Test Kitchen Driver for LXD REST API.

## Requirements

- [Oreno LXD REST API Client](https://github.com/inokappa/oreno_lxdapi)

## Installation and Setup

### Install Oreno LXD REST API Client

```sh
$ git clone https://github.com/inokappa/oreno_lxdapi.git
$ cd oreno_lxdapi
$ bundle install
$ rake install:local
```

### Install kitchen driver for LXD REST API

```sh
$ git clone https://github.com/inokappa/kitchen-lxd_api.git
$ cd kitchen-lxd_api
$ bundle install
$ rake install:local
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

platforms:
  - name: oreno-ubuntu-14.04
    driver_plugin: lxd_api
    driver_config:
      container_image: oreno-ubuntu-image
      container_name: kitchen-container
      username: kitchen

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
