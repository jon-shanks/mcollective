# == Class: mcollective::server::package
#
# Class to manage the client keys and distribute the public server key as well as the private
# and public private keys for the client to talk to the servers.
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { mcollective::client::service:
#  }
#
# === Authors
#
# Jonathan Shanks <jshanks@nyx.com>
#
# === Copyright
#
# Copyright 2013 Jon Shanks
#
class mcollective::server::package( $package  = 'pe-mcollective',
                                    $agents   = false,)
{

  package { $package:
    ensure  => installed
  }

  if $agents {
    package { $agents:
    ensure  => installed,
    require => Package[$package]
    }
  }

}

