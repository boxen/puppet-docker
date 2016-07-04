# Docker Puppet Module for Boxen

[![Build Status](https://travis-ci.org/boxen/puppet-docker.svg)](https://travis-ci.org/boxen/puppet-docker)

Installs and configures [Docker](https://www.docker.com), an open source project
to pack, ship and run any application as a lightweight container. This module will
install Docker [Compose](https://www.docker.com/docker-compose), [Engine](https://www.docker.com/docker-engine),
[Machine](https://www.docker.com/docker-machine) and [Swarm](https://www.docker.com/docker-swarm).

## Usage

```puppet
include docker
```

## Updating

Keeping Docker up-to-date is something that you should be managing in your own
Boxen repository, rather than depending on this module to update it for you.

You can update Docker by overriding the version values with Hiera (see [below](#hiera-configuration)).

## Required Puppet Modules

* `boxen`
* `homebrew`
* `ripienaar/puppet-module-data`
* `stdlib`

## Development

Write code. Run `script/cibuild` to test it. Check the `script`
directory for other useful tools.

## Hiera configuration

The following variables may be automatically overridden with Hiera:

```yaml
---
# Keep Docker up-to-date
docker::compose::version: "1.4.2"
docker::engine::version: "1.8.3"
docker::machine::version: "0.4.1"
docker::swarm::version: "0.4.0"

# The name of the local VM
docker::machinename: "local"

# Where to store the configuration and virtual machines
docker::configdir: "%{::boxen::config::configdir}/docker"
docker::datadir: "%{::boxen::config::datadir}/docker"
docker::logdir: "%{::boxen::config::logdir}/docker"
docker::vboxdir: "%{::homebrew_root}/bin"
```

It is **required** that you include
[ripienaar/puppet-module-data](https://github.com/ripienaar/puppet-module-data)
in your boxen project, as this module now ships with many pre-defined configurations
in the `data/` directory. With this module included, those
definitions will be automatically loaded, but can be overridden easily in your
own hierarchy.

You can also use JSON if your Hiera is configured for that.
