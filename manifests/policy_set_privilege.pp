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
#  windows_utensils::policy_set_privilege{'puppet':
#    identity    => "DOMAIN\User",
#    privilege   => "SeServiceLogonRight",
#    description => "Unique description"
#  }
# === Authors
#
# Michael Lucas (mike@lucasnet.org)
#
# === Copyright
#
# Copyright 2015 Michael Lucas, unless otherwise noted.
#
define windows_utensils::policy_set_privilege(
  $identity     = '',
  $privilege    = '',
  $description  = '',
  )
{
  require windows_utensils::carbon_file

  $utensilsdll = $windows_utensils::carbon_file::utensilsdll

  if(empty($identity)){
    fail('Identity is mandatory')
  }
  if(empty($privilege)){
    fail('Privilege is mandatory')
  }
  if(empty($description)){
    fail('Description is mandatory in order to make unique')
  }

  exec{"Set Privileges - $description":
    command  => "\$identity = '${identity}';\$privilege = '${privilege}';[Reflection.Assembly]::UnSafeLoadFrom(\"${utensilsdll}\");[Carbon.LSA]::GrantPrivileges(\$identity, \$privilege);",
    provider => "powershell",
    timeout  => 300,
  }
  File["${utensilsdll}"] -> Exec["Set Privileges - $description"]
}