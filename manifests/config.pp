# @api private
# This class handles nsd config. Avoid modifying private classes.
class nsd::config (
  Stdlib::Absolutepath $cfg_dir   = $nsd::params::cfg_dir,
  Stdlib::Absolutepath $cfg_file  = $nsd::params::cfg_file,
  Stdlib::Absolutepath $zones_dir = $nsd::params::zones_dir,
  Stdlib::Absolutepath $tsig_dir  = $nsd::params::tsig_dir,
) inherits nsd {

  file { $cfg_file:
    content => epp('nsd/nsd.conf.epp'),
  }
  file { $cfg_dir:
    ensure => directory,
    owner  => 0,
    group  => 0,
    mode   => '0755',
  }
  # nsd needs write access in there to save slave zones
  file { $nsd::zones_dir:
    ensure => directory,
    owner  => 'nsd',
    group  => 'nsd',
    mode   => '0750',
  }
  file { $nsd::tsig_dir:
    ensure => directory,
    owner  => 0,
    group  => 'nsd',
    mode   => '0750',
  }

}
