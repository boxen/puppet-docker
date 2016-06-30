# Public: Install and configure Docker
#
# Examples
#
#   include docker
#

class docker(
  $ensure = undef,
  $configdir = undef,
  $datadir = undef,
  $enable = undef,
  $logdir = undef,
  $machinename = undef,
  $service = undef,
  $user = undef,
  $vboxdir = undef,
) {

  validate_string(
    $ensure,
    $configdir,
    $datadir,
    $logdir,
    $machinename,
    $service,
    $user,
    $vboxdir,
  )
  validate_bool($enable)

  if $::osfamily == 'Darwin' {
    include boxen::config
  }

  class { 'docker::config':
    ensure      => $ensure,
    configdir   => $configdir,
    datadir     => $datadir,
    logdir      => $logdir,
    machinename => $machinename,
    user        => $user,
    vboxdir     => $vboxdir,
  }

  ~>
  class { [
    'docker::compose',
    'docker::engine',
    'docker::machine',
    'docker::swarm',
  ]:
    ensure      => $ensure,
  }

  ~>
  class { 'docker::service':
    ensure      => $ensure,
    configdir   => $configdir,
    datadir     => $datadir,
    enable      => $enable,
    logdir      => $logdir,
    machinename => $machinename,
    service     => $service,
    user        => $user,
    vboxdir     => $vboxdir,
  }

}
