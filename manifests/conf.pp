# Define: nsd::conf
#
define nsd::conf (
  Enum['absent','present'] $ensure = 'present',
  Optional[String] $content        = undef,
  Optional[String] $source         = undef,
  Boolean          $reload         = true,
) {
  if $ensure == 'present' and ! ($content or $source) {
    fail('nsd::conf requires content or source to be defined when the conf is present')
  }

  if $reload {
    $notify = Exec['nsd-checkconf','nsd-reload']
  } else {
    $notify = Exec['nsd-checkconf']
  }

  # the conf file
  file { "${nsd::cfg_dir}/${name}":
    ensure  => $ensure,
    content => $content,
    source  => $source,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    notify  => $notify,
  } 
}
