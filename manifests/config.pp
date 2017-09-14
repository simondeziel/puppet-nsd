# @api private
# This class handles nsd config. Avoid modifying private classes.
class nsd::config inherits nsd {
  file { $cfg_file:
    content => epp('nsd/nsd.conf.epp'),
    owner   => 0,
    group   => 0,
    mode    => '0644',
  }
  file { $cfg_dir:
    ensure  => directory,
    owner   => 0,
    group   => 0,
    mode    => '0755',
    purge   => $purge_cfg_dir,
    recurse => $purge_cfg_dir,
  }
  file { $nsd::tsig_dir:
    ensure  => directory,
    owner   => 0,
    group   => 'nsd',
    mode    => '0750',
    purge   => $purge_tsig_dir,
    recurse => $purge_tsig_dir,
  }

  # nsd needs write access in there to save slave zones
  file { $nsd::zones_dir:
    ensure  => directory,
    owner   => 'nsd',
    group   => 'nsd',
    mode    => '0750',
    purge   => $purge_zones_dir,
    recurse => $purge_zones_dir,
  }
}
