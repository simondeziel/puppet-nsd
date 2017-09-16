# @api private
# This class handles nsd services. Avoid modifying private classes.
class nsd::service inherits nsd {
  # check nsd's configs to avoid bad surprises
  exec { 'nsd-reload':
    command     => '/bin/systemctl reload nsd',
    logoutput   => 'on_failure',
    refreshonly => true,
    onlyif      => "/bin/systemctl is-active nsd && /usr/sbin/nsd-checkconf ${cfg_file}",
    # XXX: in case both a reload and a restart get scheduled in a given run.
    #      Ensures to reload (for no good but no harm) first then restart.
    before      => Service['nsd'],
  }

  # XXX: makes sure that restart/stop is only
  #      attempted when the config is good.
  # XXX: this is a kludge as having this
  # service { 'nsd':
  #   require => Exec['nsd-checkconf'],
  # }
  # didn't work, the notifies still triggered
  # a service restart even if the config was
  # invalid. The solution is to force a config check
  # prior to any restart/stop
  service { 'nsd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    restart    => "/usr/sbin/nsd-checkconf ${cfg_file} && /bin/systemctl restart nsd",
    stop       => "/usr/sbin/nsd-checkconf ${cfg_file} && /bin/systemctl stop nsd",
  }
}
