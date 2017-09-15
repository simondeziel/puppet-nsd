# @api private
# This class handles nsd params. Avoid modifying private classes.
class nsd::params {
  if ($::operatingsystem != 'Ubuntu') {
    fail("${module_name} does not support ${::operatingsystem}")
  }

  $server_options     = {
    'verbosity'    => 2,
    'hide-version' => 'yes',
    'identity'     => 'adns',
    'database'     => '',
    'zonesdir'     => '/var/lib/nsd/zones',
    'include'      => ['/etc/nsd/nsd.conf.d/*.zone',
                       '/etc/nsd/tsig/*.conf',
                       '/etc/nsd/nsd.conf.d/*.conf'],
  }

  $cfg_file           = '/etc/nsd/nsd.conf'
  $cfg_dir            = '/etc/nsd/nsd.conf.d'
  $tsig_dir           = '/etc/nsd/tsig'
  $zones_dir          = '/var/lib/nsd/zones'
  $package_ensure     = 'installed'
  $package_names      = ['nsd']
  $purge_cfg_dir      = true
  $purge_tsig_dir     = true
  $purge_zones_dir    = true
}
