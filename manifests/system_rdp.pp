# == Class: windows_utensils
#
# This module enables/disables RDP access and also will set UserConfigErrors to ignore
#
# === Parameters
#
#  Can be found on read me
#
# === Examples
#
#  windows_utensils::system_rdp{'Enable_RDP':
#    ensure  => enabled,
#  }
# === Authors
#
# Michael Lucas (mike@lucasnet.org)
#
# === Copyright
#
# Copyright 2015 Michael Lucas, unless otherwise noted.
#
define windows_utensils::system_rdp (
  $ensure,
)
{
  require windows_utensils::checkver

  if $noop == undef { $noop = false }

  case $ensure {
    'present','enabled': {
      $rdp_disabled = 0

      registry::value { 'Registry - Terminal Server - IgnoreRegUserConfigErrors':
        key   => 'HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server',
        value => 'IgnoreRegUserConfigErrors',
        type  => 'dword',
        data  => 1,
        noop  => $noop,
      }
    }
    'absent','disabled': {
      $rdp_disabled = 1
    }
    default: { fail('--> ensure metaparameter is mandatory') }
  }

  registry::value { 'Registry - Terminal Server - fDenyTSConnections':
    key   => 'HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server',
    value => 'fDenyTSConnections',
    type  => 'dword',
    data  => $rdp_disabled,
    noop  => $noop,
  }
}