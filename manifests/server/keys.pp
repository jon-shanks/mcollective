# == Class: mcollective::server::keys
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
#  class { mcollective::server::keys:
#     shared_public_key     => 'nyx-mcollective-servers-public.pem'
#     shared_private_key    => 'nyx-mcolletive-servers-private.pem',
#     ssl_client_certs      => ['public-cert.pem','another-public-cert'],
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
class mcollective::server::keys($mco_etc            = '/etc/puppetlabs/mcollective',
                                $shared_private_key = 'nyx-mcollective-servers-private.pem',
                                $shared_public_key  = 'nyx-mcollective-servers-public.pem',
                                $ssl_client_certs   = false,)
{

  file { "${mco_etc}/ssl/${shared_private_key}":
    ensure    => present,
    source    => "puppet:///modules/mcollective/${shared_private_key}",
  }

  if !defined(File["${mco_etc}/ssl/${shared_public_key}"]) {
    file { "${mco_etc}/ssl/${shared_public_key}":
      ensure    => present,
      source    => "puppet:///modules/mcollective/${shared_public_key}",
    }
  }

  if $ssl_client_certs and !empty($ssl_client_certs) {
    mcollective::client_certs { $ssl_client_certs:
      mco_etc   => $mco_etc,
    }
  }

}
