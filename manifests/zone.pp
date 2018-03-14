# Define: nsd::zone
#
define nsd::zone (
  Hash $options                        = {},
  Enum['absent','present'] $ensure     = 'present',
  Optional[String] $content            = undef,
  Optional[String] $source             = undef,
  Optional[String] $checkzone_cmd      = $nsd::checkzone_cmd,
  Variant[Boolean,String] $backup_zone = $nsd::backup_zone,
) {
  $zonename = $name ? {
    '.'     => 'root', # to host a copy of "." (RFC 7706)
    default => $name,
  }
  $zoneconf = "zone-${zonename}.conf"
  $zonefile = "${nsd::zones_dir}/${zonename}"

  # zone file
  if $ensure == 'absent' {
    # when removing a zone file, no need to reload
    # this will be done by the associated config file
    file { $zonefile:
      ensure => $ensure,
      backup => $backup_zone,
    }
  } elsif $content or $source {

    if $checkzone_cmd {
      $validate_cmd = "${checkzone_cmd} ${name} %"
    } else {
      $validate_cmd = undef
    }

    # content or source indicate a "master" zone
    # shouldn't be writable by nsd (hence owner => 0)
    file { $zonefile:
      ensure       => file,
      content      => $content,
      source       => $source,
      owner        => 0,
      group        => 'nsd',
      mode         => '0644',
      validate_cmd => $validate_cmd,
      backup       => $backup_zone,
      notify       => Exec['nsd-reload'],
    }
  } else {
    # otherwise it's a slave zone for which the file
    # shouldn't be managed (hence the ensure => undef)
    # nsd will write those itself at periodic intervals
    file { $zonefile:
      ensure => undef,
      owner  => 'nsd',
      group  => 'nsd',
      mode   => '0644',
    }
  }

  # config file associated with the zone
  if $ensure == 'present' {
    nsd::conf { $zoneconf:
      ensure  => $ensure,
      content => epp('nsd/zone.epp', { 'name' => $name, 'zonefile' => $zonefile, 'options' => $options }),
      require => File[$zonefile],
    }
  } else {
    nsd::conf { $zoneconf:
      ensure  => $ensure,
    }
  }
}
