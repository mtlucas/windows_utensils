# == Class: windows_utensils
#
# This module enables/disables UAC (User Access Control) security setting.  It will REBOOT the system if changed.
#
# === Parameters
#
#  Can be found on read me
#
# === Examples
#
#  windows_utensils::system_uac{'Disable_UAC':
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
define windows_utensils::system_uac (
  $ensure,
  $require,
  $noop,
)
{
  require windows_utensils::checkver

  if $noop == undef { $noop = false }

  case $ensure {
    'present','enabled': { $uac_data = 1 }
    'absent','disabled': { $uac_data = 0 }
    default: { fail('--> ensure metaparameter is mandatory') }
  }

  registry::value {'Registry - UAC':
    key       => 'HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System',
    value     => 'EnableLUA',
    type      => 'dword',
    data      => $uac_data,
    noop      => $noop,
  }
  reboot { 'Reboot_after_UAC_change':
    subscribe => Registry::Value['Registry - UAC'],
    noop      => $noop,
  }
}