# @api private
# This class handles nsd packages. Avoid modifying private classes.
class nsd::install inherits nsd {
  package { $nsd::package_names:
    ensure => $nsd::package_ensure,
  }
}
