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
    'include'      => ['/etc/nsd/nsd.conf.d/*.conf','/etc/nsd/tsig/*.conf'],
  }

  $cfg_file           = '/etc/nsd/nsd.conf'
  $cfg_dir            = '/etc/nsd/nsd.conf.d'
  $tsig_dir           = '/etc/nsd/tsig'
  $zones_dir          = '/var/lib/nsd/zones'
  $package_ensure     = 'installed'
  $package_names      = ['nsd','bind9utils']
  # strict checking
  $checkzone_cmd      = '/usr/sbin/named-checkzone -k fail -m fail -M fail -n fail -S fail'
  $backup_zone        = false
  $purge_cfg_dir      = true
  $purge_tsig_dir     = true
  $purge_zones_dir    = true
}
