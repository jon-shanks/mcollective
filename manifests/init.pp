# == Class: mcollective
#
# Manages the configuration and setup of mcollective server and client, it pulls down hiera data and passes the data to the
# client or server module depending on what is configured and set. By default, niether client or server is enabled.
#
# === Parameters
#
# [*main_collective*]
#   The main default standard mcollective queue
# [*server*]
#   Whether or not to install the server and configure it.
# [*server_subcollectives*]
#   The subcollectives to subscribe to by the servers
# [*server_log_level*]
#   The log level for the server.
# [*server_daemonize*]
#   Whether or not to daemonize the server
# [*mco_etc*]
#   The mcollective etc directory
# [*server_shared_private_key*]
#   The shared server private key, all servers get this
# [*server_shared_public_key*]
#   The shared server public key, all servers get this.
# [*server_ssl_client_certs*]
#   A list of client certificates used by the servers to be able to decrypt messages for the relevant clients. This is an Array
# [*server_activemq_servers*]
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
# [*server_mco_interval*]
#   The interval to wait between registration messages. 0 disables registration.
# [*server_package*]
#   The server package, this is the standard mcollective server package
# [*server_agents*]
#   The server agents, this is a hiera_array merge throughout hiera to install the necessary agent packages required on the box
# [*client*]
#   Whether or not to install the client, (boolean, true or false)
# [*client_subcollectives*]
#   The subcollectives the client subscribes to, it will listen for messages on those message queues.
# [*client_shared_public_key*]
#   The shared public key that the servers all use, used to decrypt the response payload from the servers
# [*client_activemq_servers*]
#   The activemq message broker servers, this is an array and used by the client to send messages to the relevant queues.
# [*client_log_level*]
#   The log level to use inside client.cfg
# [*client_public_key*]
#   The client public key, also used on the servers relevant to be able to decrypt the data when it receives it.
# [*client_private_key*]
#   The private key of the client, used to encrypt the payload to the servers of the command
# [*client_package*]
#   The main mcollective client package
# [*client_agents*]
#   Fetch client agents, this is a hiera_array merge throughout hiera to gather different agents and install
#
# === Variables
#
# === Examples
#
#  class { mcollective:
#     server    => true,
#     server_subcollectives   => ['this', 'that'],
#     server_ssl_client_certs => ['this_ssl_public_key.pem'],
#     server_activemq_servers => ['pb2svamq01v', 'pb2svamq02v'],
#     mq_user                 => 'user1',
#     mq_pass                 => 'somecrazypassword',
#     server_agents           => ['pe-mcollective-git-agent'],
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
class mcollective($main_collective            = 'mcollective',
                  $server                     = false,
                  $server_subcollectives      = false,
                  $server_log_level           = 'info',
                  $server_daemonize           = '1',
                  $mco_etc                    = '/etc/mcollective',
                  $libdir                     = '/usr/libexec/mcollective',
                  $logdir                     = '/var/log/mcollective',
                  $logfile                    = '/var/log/mcollective/mcollective.log',
                  $service_name               = 'mcollective',
                  $server_shared_private_key  = 'mcollective-servers-private.pem',
                  $server_shared_public_key   = 'mcollective-servers-public.pem',
                  $server_ssl_client_certs    = [],
                  $server_activemq_servers    = [],
                  $puppet_resource_manage     = false,
                  $puppet_resource_whitelist  = false,
                  $puppet_resource_blacklist  = false,
                  $mq_port                    = '61613',
                  $mq_user                    = 'mcollective',
                  $mq_pass                    = 'mcollective',
                  $mq_ssl                     = 'true',
                  $ssl_cert_dir               = '/var/lib/puppet/ssl',
                  $server_mco_interval        = '600',
                  $server_package             = 'mcollective',
                  $server_agents              = hiera_array('mcollective::server_agents', false),
                  $server_classfile           = '/var/lib/puppet/classes.txt',
                  $server_puppet_bin          = '/usr/bin/puppet',
                  $server_puppet_config       = '/etc/puppet/puppet.conf',
                  $client                     = false,
                  $client_subcollectives      = false,
                  $client_shared_public_key   = false,
                  $client_activemq_servers    = [],
                  $client_log_level           = 'info',
                  $client_public_key          = false,
                  $client_private_key         = false,
                  $client_package             = 'mcollective-client',
                  $client_agents              = hiera_array('mcollective::client_agents', false))
{

  if $server {
    class { 'mcollective::server':
      main_collective             => $main_collective,
      subcollectives              => $server_subcollectives,
      log_level                   => $server_log_level,
      daemonize                   => $server_daemonize,
      mco_etc                     => $mco_etc,
      libdir                      => $libdir,
      logdir                      => $logdir,
      logfile                     => $logfile,
      shared_private_key          => $server_shared_private_key,
      shared_public_key           => $server_shared_public_key,
      ssl_client_certs            => $server_ssl_client_certs,
      activemq_servers            => $server_activemq_servers,
      puppet_resource_manage      => $puppet_resource_manage,
      puppet_resource_whitelist   => $puppet_resource_whitelist,
      puppet_resource_blacklist   => $puppet_resource_blacklist,
      mq_port                     => $mq_port,
      mq_user                     => $mq_user,
      mq_pass                     => $mq_pass,
      mq_ssl                      => $mq_ssl,
      service_name                => $service_name,
      ssl_cert_dir                => $ssl_cert_dir,
      mco_interval                => $server_mco_interval,
      package                     => $server_package,
      agents                      => $server_agents,
      classfile                   => $server_classfile,
      puppet_bin                  => $server_puppet_bin,
      puppet_config               => $server_puppet_config,
    }
  }

  if $client {
    class { 'mcollective::client':
      main_collective     => $main_collective,
      subcollectives      => $client_subcollectives,
      log_level           => $client_log_level,
      logdir              => $logdir,
      logfile             => $logfile,
      libdir              => $libdir,
      mco_etc             => $mco_etc,
      shared_public_key   => $client_shared_public_key,
      client_public_key   => $client_public_key,
      client_private_key  => $client_private_key,
      activemq_servers    => $client_activemq_servers,
      mq_port             => $mq_port,
      mq_user             => $mq_user,
      mq_pass             => $mq_pass,
      mq_ssl              => $mq_ssl,
      ssl_cert_dir        => $ssl_cert_dir,
      package             => $client_package,
      agents              => $client_agents,
    }
  }
    
}
