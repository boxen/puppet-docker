# Internal: Manage configuration files for docker

class docker::config(
  $ensure = undef,
  $configdir = undef,
  $datadir = undef,
  $logdir = undef,
  $machinename = undef,
  $user = undef,
  $vboxdir = undef,
) {

  $dir_ensure = $ensure ? {
    present => directory,
    default => absent,
  }

  file { [
    $configdir,
    $datadir,
    $logdir,
  ]:
    ensure => $dir_ensure,
    owner  => $user,
  }

  if $::osfamily == 'Darwin' {
    file { "${configdir}/profile":
      ensure => absent,
    }

    boxen::env_script { 'docker':
      ensure   => $ensure,
      content  => template('docker/darwin/env.sh.erb'),
      priority => 'lower',
    }
  }

}
