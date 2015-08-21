# == Class: windows_utensils
#
# This module allow you to manage User Rights Policies of a Windows service
#
# === Parameters
#
#  Can be found on read me
#
# === Examples
#
#  windows_utensils::setpriv{'puppet':
#    identity    = "DOMAIN\User",
#    privilege    = "SeServiceLogonRight",
#  }
# === Authors
#
# Michael Lucas (mike@lucasnet.org)
#
# === Copyright
#
# Copyright 2015 Michael Lucas, unless otherwise noted.
#
define windows_utensils::setpriv(
  $identity    = '',
  $privilege    = '',
  $utensilsdll   = "C:\\windows\\carbon.dll",
  )
{
  if(empty($identity)){
    fail('Identity is mandatory')
  }
  if(empty($privilege)){
    fail('Privilege is mandatory')
  }
  file{"${utensilsdll}":
    source => "puppet:///modules/windows_utensils/carbon.dll",
    source_permissions => ignore,
  }
  exec{"Set Privileges - $privilege":
    command  => "\$identity = '${identity}';\$privilege = '${privilege}';[Reflection.Assembly]::UnSafeLoadFrom(\"${utensilsdll}\");[utensils.LSA]::GrantPrivileges(\$identity, \$privilege);",
    provider => "powershell",
    timeout  => 30,
  }

  File["${utensilsdll}"] -> Exec["Set Privileges - $privilege"]
}