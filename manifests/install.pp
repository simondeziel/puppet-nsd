# @api private
# This class handles nsd packages. Avoid modifying private classes.
class nsd::install inherits nsd {
  package { $package_names:
    ensure => $package_ensure,
  }
}
