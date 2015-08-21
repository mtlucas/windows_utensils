# == Class: windows_utensils
#
# This module allow you to manage Windows service credentials
#
# === Parameters
#
#  Can be found on read me
#
# === Examples
#
#  windows_utensils::credentials{'puppet':
#    username    = "DOMAIN\User",
#    password    = "P@ssw0rd",
#    servicename = "puppet",
#  }
# === Authors
#
# Michael Lucas (mike@lucasnet.org)
#
# === Copyright
#
# Copyright 2015 Michael Lucas, unless otherwise noted.
#
define windows_utensils::credentials(
  $username    = '',
  $password    = '',
  $servicename = '',
  $delayed     = false,
)
{
  require windows_utensils::carbon_file

  $utensilsdll = $windows_utensils::carbon_file::utensilsdll
  
  if(empty($username)){
    fail('Username is mandatory')
  }
  if(empty($password)){
    fail('Password is mandatory')
  }
  if(empty($servicename)){
    fail('servicename is mandatory')
  }
  validate_bool($delayed)

  exec{"Change credentials - $servicename":
    command  => "\$username = '${username}';\$password = '${password}';\$privilege = \"SeServiceLogonRight\";[Reflection.Assembly]::UnSafeLoadFrom(\"${utensilsdll}\");[Carbon.LSA]::GrantPrivileges(\$username, \$privilege);\$serverName = \$env:COMPUTERNAME;\$service = '${servicename}';\$svcD=gwmi win32_service -computername \$serverName -filter \"name='\$service'\";\$StopStatus = \$svcD.StopService();\$ChangeStatus = \$svcD.change(\$null,\$null,\$null,\$null,\$null,\$null,\$username,\$password,\$null,\$null,\$null);",
    provider => "powershell",
    timeout  => 300,
    onlyif   => "\$username = '${username}';\$password = '${password}';\$serverName = \$env:COMPUTERNAME;\$service = '${servicename}';\$svcD=gwmi win32_service -computername \$serverName -filter \"name='\$service'\";if(\$svcD.GetPropertyValue('startname') -like '${username}'){exit 1}",
  }
  File["${utensilsdll}"] -> Exec["Change credentials - $servicename"]
}