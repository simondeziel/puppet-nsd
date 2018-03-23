# Define: nsd::tsig
#
# Parameters:
#
# $ensure = ensure the persence or absence of the tsig key.
# $keyname = the name given to the TSIG KEY. This must be unique. This defaults to
#   the namevar.
# $algorithm = Defined algorithm of the key
# $secret = shared secret of the key
#
# To generate the secret (be patient or use -r /dev/urandom):
#  tsig-keygen -a hmac-sha512 foo
#
# Usage:
#
# nsd::tsig { 'ns3':
#   algorithm => 'hmac-sha512'
#   secret    => 'Kmx0RGasejvesXopWfOPVQ==',
# }
#
define nsd::tsig (
  String $secret,
  String $algorithm                = 'hmac-sha512',
  Enum['present','absent'] $ensure = present
) {
  file { "${nsd::tsig_dir}/${name}.conf":
    owner     => 0,
    group     => 'nsd',
    mode      => '0640',
    content   => epp('nsd/tsig.epp', { 'name' => $name, 'algorithm' => $algorithm, 'secret' => $secret }),
    notify    => Exec['nsd-reload'],
    show_diff => false,
  }
}
