# @api private
# This class handles nsd exec actions. Avoid modifying private classes.
class nsd::exec inherits nsd {
  # check nsd's configs to avoid bad surprises
  exec { 'nsd-reload':
    command     => '/bin/systemctl reload nsd',
    logoutput   => 'on_failure',
    refreshonly => true,
    onlyif      => "/bin/systemctl is-active nsd && /usr/sbin/nsd-checkconf ${cfg_file}",
  }

  exec { 'nsd-restart':
    command     => "/usr/sbin/nsd-checkconf ${cfg_file}",
    logoutput   => 'on_failure',
    refreshonly => true,
    notify      => Class['::nsd::service'],
  }
}
