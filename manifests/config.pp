# @api private
# This class handles nsd config. Avoid modifying private classes.
class nsd::config inherits nsd {
  exec { 'nsd-reload':
    command     => 'service nsd reload',
    logoutput   => 'on_failure',
    refreshonly => true,
    # XXX: quirk to avoid a require => Service['nsd']
    #      that creates a dependency loop
    onlyif      => 'service nsd status',
    require     => Exec['nsd-checkconf'],
  }

  # Check nsd's configs to avoid bad surprises
  exec { 'nsd-checkconf':
    command     => '/usr/sbin/nsd-checkconf /etc/nsd/nsd.conf',
    logoutput   => 'on_failure',
    refreshonly => true,
  }

  file { $cfg_file:
    content => epp('nsd/nsd.conf.epp'),
    owner   => 0,
    group   => 0,
    mode    => '0644',
    notify  => [Exec['nsd-checkconf'],Class['::nsd::service']],
  }
  # TODO: have that file use the k,v templating
  #       coupled with good hiera defaults
  # XXX: nsd::conf will trigger a reload and the nsd::config
  #      class will notify the service (trigger a restart)
  #      It should be fine to apply any config change
  nsd::conf { 'server.conf':
    content => epp('nsd/server.conf.epp', { 'options' => $server_options }),
    reload  => false,
  } ~> Class['::nsd::service']
  file { $cfg_dir:
    ensure  => directory,
    owner   => 0,
    group   => 0,
    mode    => '0755',
    purge   => $purge_cfg_dir,
    recurse => $purge_cfg_dir,
    notify  => [Exec['nsd-checkconf'],Class['::nsd::service']],
  }
  file { $nsd::tsig_dir:
    ensure  => directory,
    owner   => 0,
    group   => 'nsd',
    mode    => '0750',
    purge   => $purge_tsig_dir,
    recurse => $purge_tsig_dir,
    notify  => Exec['nsd-checkconf','nsd-reload'],
  }

  # nsd needs write access in there to save slave zones
  file { $nsd::zones_dir:
    ensure  => directory,
    owner   => 'nsd',
    group   => 'nsd',
    mode    => '0750',
    purge   => $purge_zones_dir,
    recurse => $purge_zones_dir,
    notify  => Exec['nsd-checkconf','nsd-reload'],
  }
}
