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

  # content or source are used for "master" zones
  # which shouldn't be writeable by nsd
  if $content or $source {
    $owner = 0
  } else {
    $owner = 'nsd'
  }
  
  # the zone file itself
  file { "${nsd::zones_dir}/${name}":
    ensure       => $ensure,
    content      => $content,
    source       => $source,
    owner        => $owner,
    group        => 'nsd',
    mode         => '0644',
    validate_cmd => $checkzone_cmd,
    backup       => $backup_zone,
  }

  # the config file for that zone
  nsd::conf { "zone-${name}.conf":
    ensure  => $ensure,
    content => epp('nsd/zone.epp', { 'name' => $name, 'options' => $options }),
    require => File["${nsd::zones_dir}/${name}"],
  }
}
