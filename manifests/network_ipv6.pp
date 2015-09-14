# == Class: windows_utensils
#
# This module enables/disable IPv6
#
# === Parameters
#
#  Can be found on read me
#
# === Examples
#
#  windows_utensils::network_ipv6{'Disable_IPv6':
#    ensure  => disabled,
#    state   => 'all',
#  }
# === Authors
#
# Michael Lucas (mike@lucasnet.org)
#
# === Copyright
#
# Copyright 2015 Michael Lucas, unless otherwise noted.
#
define windows_utensils::network_ipv6 (
  $ensure,
  $state = undef,
)
{
  require windows_utensils::checkver

  if $noop == undef { $noop = false }

  case $ensure {
    'present','enabled': {
      case $state {
        undef,'all': { $ipv6_data = '0' }
        'preferred': { $ipv6_data = '0x20' }
        'nontunnel': { $ipv6_data = '0x10' }
        'tunnel':    { $ipv6_data = '0x01' }
        default:     { $ipv6_data = '0' }
      }
    }
    'absent','disabled': { $ipv6_data = '0xffffffff' }
    default: { fail('--> ensure metaparameter is mandatory') }
  }

  registry::value {'Registry - IPv6':
    key    => 'HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters',
    value  => 'DisabledComponents',
    type   => 'dword',
    data   => $ipv6_data,
    noop   => $noop,
  }
}