# @api private
# This class handles nsd params. Avoid modifying private classes.
class nsd::params {
  if ($::operatingsystem != 'Ubuntu') {
    fail("${module_name} does not support ${::operatingsystem}")
  }

  $cfg_file            = '/etc/nsd/nsd.conf'
  $cfg_dir             = '/etc/nsd/nsd.conf.d'
  $tsig_dir            = '/etc/nsd/tsig'
  $zones_dir           = '/var/lib/nsd/zones'
  $fragments_dir       = '/var/lib/nsd/fragments'
  $package_ensure      = 'installed'
  $package_names       = ['nsd']
  $checkzone_cmd       = '/usr/sbin/nsd-checkzone'
  $backup_zone         = false
  $purge_cfg_dir       = true
  $purge_tsig_dir      = true
  $purge_zones_dir     = true
  $purge_fragments_dir = true
  $server_options      = {
    'verbosity'    => 2,
    'hide-version' => 'yes',
    'identity'     => 'adns',
    'database'     => '',
    'zonesdir'     => $zones_dir,
    'include'      => ["${cfg_dir}/*.conf","${tsig_dir}/*.conf"],
  }
}
