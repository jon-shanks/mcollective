# == Class: mcollective::server
#
# Full description of class mcollective here.
#
# === Parameters

# [*main_collective*]
#   The main default standard mcollective queue
# [*subcollectives*]
#   The subcollectives to subscribe to by the servers
# [*log_level*]
#   The log level for the server.
# [*daemonize*]
#   Whether or not to daemonize the server
# [*mco_etc*]
#   The mcollective etc directory
# [*shared_private_key*]
#   The shared server private key, all servers get this
# [*shared_public_key*]
#   The shared server public key, all servers get this.
# [*ssl_client_certs*]
#   A list of client certificates used by the servers to be able to decrypt messages for the relevant clients. This is an Array
# [*activemq_servers*]
#   The activemq message broker servers used by the server, to connect to. This is an Array
# [*mq_port*]
#   The port to use to connect to activemq
# [*mq_user*]
#   The user to use to connect to activemq
# [*mq_pass*]
#   The password used for the user specified to connect to activemq
# [*mq_ssl*]
#   Whether to use ssl to the activemq message broker
# [*ssl_cert_dir*]
#   The directory holding the certificates, this differs between a puppet worker and a puppet agent only
# [*mco_interval*]
#   The interval to wait between registration messages. 0 disables registration.
# [*package*]
#   The server package, this is the standard mcollective server package
# [*agents*]
#   The server agents, this is a hiera_array merge throughout hiera to install the necessary agent packages required on the box
#
# === Examples
#
#  class { mcollective::server:
#  }
#
# === Authors
#
# Jonathan Shanks <jon.shanks@gmail.com>
#
# === Copyright
#
# Copyright 2013 Jon Shanks
#
class mcollective::server($main_collective            = 'mcollective',
                          $subcollectives             = false,
                          $log_level                  = 'info',
                          $libdir                     = '/usr/libexec/mcollective',
                          $logdir                     = '/var/log/mcollective',
                          $logfile                    = '/var/log/mcollective/mcollective.log',
                          $daemonize                  = '1',
                          $mco_etc                    = '/etc/mcollective',
                          $shared_private_key         = 'nyx-mcollective-servers-private.pem',
                          $shared_public_key          = 'nyx-mcollective-servers-public.pem',
                          $puppet_resource_manage     = false,
                          $puppet_resource_whitelist  = false,
                          $puppet_resource_blacklist  = false,
                          $ssl_client_certs           = [],
                          $activemq_servers           = ['localhost'],
                          $mq_port                    = '61613',
                          $mq_user                    = 'mcollective',
                          $mq_pass                    = 'mcollective',
                          $mq_ssl                     = 'true',
                          $service_name               = 'mcollective',
                          $ssl_cert_dir               = '/var/opt/lib/pe-puppet/ssl',
                          $mco_interval               = '600',
                          $package                    = 'pe-mcollective',
                          $puppet_bin                 = '/usr/bin/puppet',
                          $puppet_config              = '/etc/puppet/puppet.conf',
                          $classfile                  = '/var/lib/puppet/classes.txt',
                          $agents                     = false,)
{

  File { mode => '0600', owner => 'root', group => 'root' }

  class { 'mcollective::server::package':
    package => $package,
    agents  => $agents,
  }

  class { 'mcollective::server::service':
    sname   => $service_name,
  }

  class { 'mcollective::server::keys':
    mco_etc            => $mco_etc,
    shared_private_key => $shared_private_key,
    shared_public_key  => $shared_public_key,
    ssl_client_certs   => $ssl_client_certs,
  }

  class { 'mcollective::facts': 
    mco_etc            => $mco_etc,
  }

  if !defined(File[$logdir]) {
    file { $logdir:
      ensure => directory,
      mode   => '0755',
    }
  }

  file { "${mco_etc}/server.cfg":
    ensure    => present,
    content   => template('mcollective/server.cfg.erb'),
  }

  Class['mcollective::server::package'] -> Class['mcollective::facts'] ~> Class['mcollective::server::service']

  Class['mcollective::server::package'] -> File["${mco_etc}/server.cfg"] ->  Class['mcollective::server::keys'] ~> Class['mcollective::server::service']

}
  
