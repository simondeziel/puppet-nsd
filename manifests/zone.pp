# Define: nsd::zone
#
define nsd::zone (
  Optional[Hash] $options              = undef,
  Enum['absent','present'] $ensure     = 'present',
  Optional[String] $content            = undef,
  Optional[String] $source             = undef,
  String $checkzone_cmd                = "${nsd::checkzone_cmd} ${name} %",
  Variant[Boolean,String] $backup_zone = $nsd::backup_zone,
) {
  if $ensure == 'present' and ! $options {
    fail('nsd::zone requires the options hash when the zone is present')
  }

  # zone file
  if $ensure == 'absent' {
    # when removing a zone file, no need to reload
    # this will be done by the associated config file
    file { "${nsd::zones_dir}/${name}":
      ensure => $ensure,
      backup => $backup_zone,
    }
  } elsif $content or $source {
    # content or source indicate a "master" zone
    # shouldn't be writable by nsd (hence owner => 0)
    file { "${nsd::zones_dir}/${name}":
      ensure       => file,
      content      => $content,
      source       => $source,
      owner        => 0,
      group        => 'nsd',
      mode         => '0644',
      validate_cmd => $checkzone_cmd,
      backup       => $backup_zone,
      notify       => Exec['nsd-reload'],
    }
  } else {
    # otherwise it's a slave zone for which the file
    # shouldn't be managed (hence the ensure => undef)
    # nsd will write those itself at periodic intervals
    file { "${nsd::zones_dir}/${name}":
      ensure => undef,
      owner  => 'nsd',
      group  => 'nsd',
      mode   => '0644',
    }
  }

  # config file associated with the zone
  if $ensure == 'present' {
    nsd::conf { "zone-${name}.conf":
      ensure  => $ensure,
      content => epp('nsd/zone.epp', { 'name' => $name, 'options' => $options }),
      require => File["${nsd::zones_dir}/${name}"],
    }
  } else {
    nsd::conf { "zone-${name}.conf":
      ensure  => $ensure,
    }
  }
}
