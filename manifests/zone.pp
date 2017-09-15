# Define: nsd::zone
#
define nsd::zone (
  Optional[Hash] $options          = undef,
  Enum['absent','present'] $ensure = 'present',
  Optional[String] $content        = undef,
  Optional[String] $source         = undef,
) {
  if $ensure == 'present' and ! $options {
    fail('nsd::zone requires the options hash when the zone is present')
  }

  # content or source are used for "master" zones
  # which shouldn't be writeable by nsd
  if $content or $source {
    $mode = '0440'
  } else {
    $mode = '0640'
  }
  
  # the zone file itself
  file { "${nsd::zones_dir}/${name}":
    ensure  => $ensure,
    content => $content,
    source  => $source,
    owner   => 'nsd',
    group   => 'nsd',
    mode    => $mode,
    notify  => Exec['nsd-reload'],
  }

  # the config file for that zone
  file { "${nsd::cfg_dir}/${name}.zone":
    ensure  => $ensure,
    content => epp('nsd/zone.epp', { 'name' => $name, 'options' => $options }),
    notify  => Exec['nsd-checkconf','nsd-reload'],
  }
}
