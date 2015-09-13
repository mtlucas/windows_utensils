# == Class: windows_utensils
#
# This module enables/disables Windows Firewall across all profiles
#
# === Parameters
#
#  Can be found on read me
#
# === Examples
#
#  windows_utensils::network_firewall{'Disable_Windows_Firewall':
#    ensure  => disabled,
#  }
# === Authors
#
# Michael Lucas (mike@lucasnet.org)
#
# === Copyright
#
# Copyright 2015 Michael Lucas, unless otherwise noted.
#
define windows_utensils::network_firewall (
  $ensure,
)
{
  require windows_utensils::checkver

  case $ensure {
    'present','enabled': { $firewall_setting = 1 }
    'absent','disabled': { $firewall_setting = 0 }
    default: { fail('--> ensure metaparameter is mandatory') }
  }

  registry::value { 'Registry - Windows Firewall - DomainProfile':
    key   => 'HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile',
    value => 'EnableFirewall',
    type  => 'dword',
    data  => $firewall_setting,
  }
  registry::value { 'Registry - Windows Firewall - PublicProfile':
    key   => 'HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile',
    value => 'EnableFirewall',
    type  => 'dword',
    data  => $firewall_setting,
  }
  registry::value { 'Registry - Windows Firewall - StandardProfile':
    key   => 'HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile',
    value => 'EnableFirewall',
    type  => 'dword',
    data  => $firewall_setting,
  }
}

