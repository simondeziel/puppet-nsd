# @api private
# This class handles nsd services. Avoid modifying private classes.
class nsd::service inherits nsd {
  service { 'nsd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
