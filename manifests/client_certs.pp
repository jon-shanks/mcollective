# == Define: mcollective::client_certs
#
# Ships the client certificates from an array of client certificates, could use foreach or each
# but due to a bug in the future parser, (which is fixed in 3.4.0) we can't use those functions.
# http://projects.puppetlabs.com/issues/22498
#
# === Parameters
#
# === Variables
# *$file*
#   uses the name passed to the define, which is each element in the array once flattened
#
# === Examples
#
#  client_certs { ["eu_puppet_clusters.pem", "some_other_cert.pem"]:
#  }
#
# === Authors
#
# Jonathan Shanks <jon.shanks@gmail.com>
#
# === Copyright
#
# Jon Shanks 2013
#

define mcollective::client_certs($mco_etc = '/etc/puppetlabs/mcollective') {
  File { mode => '0600', owner => 'root', group => 'root' }

  $file = $name

  if !defined(File["${mco_etc}/ssl/clients/${file}"]) {
    file { "${mco_etc}/ssl/clients/${file}":
      ensure  => present,
      source  => "puppet:///modules/mcollective/clients/${file}",
    }
  }
}
