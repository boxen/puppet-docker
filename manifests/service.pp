# Internal: Manage the Docker service

class docker::service(
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

  $service_ensure = $ensure ? {
    present => running,
    default => stopped,
  }

  if $::osfamily == 'Darwin' {
    include boxen::config

    $executable = "${boxen::config::homebrewdir}/bin/docker-machine"

    $command = $ensure ? {
      present => "${executable} create --driver=virtualbox ${machinename}",
      default => "${executable} rm ${machinename}",
    }

    $unless = $ensure ? {
      present => "${executable} status ${machinename}",
      default => undef,
    }

    exec { 'docker-machine create':
      command     => $command,
      environment => [
        "DOCKER_CONFIG=${configdir}",
        "MACHINE_STORAGE_PATH=${datadir}",
      ],
      user    => $user,
      unless  => $unless,
      path    => "${vboxdir}:${::path}",
      before  => Service['docker'],
      notify  => Service['docker'];
    }

    file { "/Library/LaunchDaemons/${service}.plist":
      ensure  => $ensure,
      content => template('docker/darwin/dev.docker.plist.erb'),
      group   => 'wheel',
      owner   => 'root',
      before  => Service['docker'],
    }
  }

  service { $service:
    ensure => $service_ensure,
    enable => $enable,
    alias  => 'docker',
  }

}
