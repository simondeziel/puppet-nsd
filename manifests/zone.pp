# Define: nsd::zone
#
define nsd::zone (
  Optional[Hash] $options          = undef,
  Enum['absent','present'] $ensure = 'present',
  Optional[String] $content        = undef,
  Optional[String] $source         = undef,
  String $checkzone_cmd            = "${nsd::checkzone_cmd} ${name} %",
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
    notify       => Exec['nsd-reload'],
    validate_cmd => $checkzone_cmd,
  }

  # the config file for that zone
  file { "${nsd::cfg_dir}/zone-${name}.conf":
    ensure  => $ensure,
    content => epp('nsd/zone.epp', { 'name' => $name, 'options' => $options }),
    notify  => Exec['nsd-reload'],
  }
}
