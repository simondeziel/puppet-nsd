#
# Class: nsd
#
class nsd (
  Hash $server_options            = $nsd::params::server_options,
  Stdlib::Absolutepath $cfg_file  = $nsd::params::cfg_file,
  Stdlib::Absolutepath $cfg_dir   = $nsd::params::cfg_dir,
  Stdlib::Absolutepath $tsig_dir  = $nsd::params::tsig_dir,
  Stdlib::Absolutepath $zones_dir = $nsd::params::zones_dir,
  Array[String] $package_names    = $nsd::params::package_names,
  String $package_ensure          = $nsd::params::package_ensure,
  Boolean $purge_cfg_dir          = $nsd::params::purge_cfg_dir,
  Boolean $purge_tsig_dir         = $nsd::params::purge_tsig_dir,
  Boolean $purge_zones_dir        = $nsd::params::purge_zones_dir,
) inherits nsd::params {
  contain nsd::install
  contain nsd::config
  contain nsd::service

  # do not notify the service class
  # since we want to be able to do reloads
  Class['::nsd::install']
  -> Class['::nsd::config']
  -> Class['::nsd::service']
}

