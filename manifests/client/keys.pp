# == Class: mcollective::client::keys
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
#  class { mcollective::client::keys:
#     shared_public_key   => 'nyx-mcollective-shared-public.pem'
#     client_public_key   => 'some-public-key.pem',
#     client_private_key  => 'some-private-key.pem',
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

class mcollective::client::keys($shared_public_key  = '',
                                $client_public_key  = false,
                                $client_private_key = false,
                                $mco_etc            = '/etc/puppetlabs/mcollective')
{

  if !defined(File["${mco_etc}/ssl/${shared_public_key}"]) {
    file { "${mco_etc}/ssl/${shared_public_key}":
      ensure    => present,
      source    => "puppet:///modules/mcollective/${shared_public_key}",
    }
  }

  if $client_public_key and $client_private_key {
    if !defined(File["${mco_etc}/ssl/${client_public_key}"]) {
      file { "${mco_etc}/ssl/${client_public_key}":
        ensure    => present,
        source    => "puppet:///modules/mcollective/clients/${client_public_key}",
      }
    }
   
    if !defined(File["${mco_etc}/ssl/${client_private_key}"]) {
      file { "${mco_etc}/ssl/${client_private_key}":
        ensure    => present,
        source    => "puppet:///modules/mcollective/clients/${client_private_key}",
      }
    }
  }

}

