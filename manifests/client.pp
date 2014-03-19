# == Class: mcollective::client
#
# Class to install and configure the mcollective client
#
# === Parameters

# [*subcollectives*]
#   The subcollectives the client subscribes to, it will listen for messages on those message queues.
# [*shared_public_key*]
#   The shared public key that the servers all use, used to decrypt the response payload from the servers
# [*activemq_servers*]
#   The activemq message broker servers, this is an array and used by the client to send messages to the relevant queues.
# [*log_level*]
#   The log level to use inside client.cfg
# [*public_key*]
#   The client public key, also used on the servers relevant to be able to decrypt the data when it receives it.
# [*private_key*]
#   The private key of the client, used to encrypt the payload to the servers of the command
# [*package*]
#   The main mcollective client package
# [*agents*]
#   Fetch client agents, this is a hiera_array merge throughout hiera to gather different agents and install
#

# === Examples
#
#  class { mcollective:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class mcollective::client($main_collective    = 'mcollective',
                          $subcollectives     = false,
                          $logdir             = '/var/log/mcollective',
                          $log_level          = 'info',
                          $libdir             = '/usr/libexec/mcollective',
                          $logfile            = '/var/log/mcollective/mcollective.log',
                          $mco_etc            = '/etc/mcollective',
                          $shared_public_key  = 'mcollective-servers-public.pem',
                          $client_public_key  = false,
                          $client_private_key = false,
                          $activemq_servers   = ['localhost'],
                          $mq_port            = '61613',
                          $mq_user            = 'mcollective',
                          $mq_pass            = 'mcollective',
                          $mq_ssl             = 'true',
                          $ssl_cert_dir       = '/var/lib/puppet/ssl',
                          $package            = 'mcollective-client',
                          $agents             = false)
                          
{

  File { mode => '0600', owner => 'root', group => 'root' }

  package { $package:
    ensure  => installed
  }

  if $agents {
    package { $agents:
      ensure  => installed,
      require => Package[$package],
    }
  }

  if !defined(File[$logdir]) {
    file { $logdir:
      ensure => directory,
      mode   => '0755',
    }
  }

  file { "${mco_etc}/client.cfg":
    ensure    => present,
    content   => template('mcollective/client.cfg.erb'),
    require   => Package[$package],
  }

  class { 'mcollective::client::keys':
    mco_etc            => $mco_etc,
    shared_public_key  => $shared_public_key,
    client_public_key  => $client_public_key,
    client_private_key => $client_private_key,
  }

  Package[$package] -> File["${mco_etc}/client.cfg"] -> Class['mcollective::client::keys']

}
  
