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
#  windows_utensils::service_credentials{'puppet':
#    username    => "DOMAIN\User",
#    password    => "P@ssw0rd",
#    servicename => "puppet",
#  }
# === Authors
#
# Michael Lucas (mike@lucasnet.org)
#
# === Copyright
#
# Copyright 2015 Michael Lucas, unless otherwise noted.
#
define windows_utensils::service_credentials (
  $username    = '',
  $password    = '',
  $servicename = '',
  $delayed     = false,
)
{
  require windows_utensils::checkver
  require windows_utensils::carbon_file

  $utensilsdll = $windows_utensils::carbon_file::utensilsdll

  if $noop == undef { $noop = false }

  if(empty($username)) {
    fail('--> username metaparameter is mandatory')
  }
  if(empty($password)) {
    fail('--> password metaparameter is mandatory')
  }
  if(empty($servicename)) {
    fail('--> servicename metaparameter is mandatory')
  }
  validate_bool($delayed)

  $regex_username = regsubst($username, "(\\)", "\\\\", 'G')

  exec {"Change credentials - $servicename":
    command  => "\$username = '${username}';\$password = '${password}';\$privilege = \"SeServiceLogonRight\";[Reflection.Assembly]::UnSafeLoadFrom(\"${utensilsdll}\");[Carbon.LSA]::GrantPrivileges(\$username, \$privilege);\$serverName = \$env:COMPUTERNAME;\$service = '${servicename}';\$svcD=gwmi win32_service -computername \$serverName -filter \"name='\$service'\";\$StopStatus = \$svcD.StopService();\$ChangeStatus = \$svcD.change(\$null,\$null,\$null,\$null,\$null,\$null,\$username,\$password,\$null,\$null,\$null);",
    provider => "powershell",
    timeout  => 300,
    unless   => "\$svcD=gwmi win32_service -computername \$env:COMPUTERNAME -filter \"name='${servicename}'\";if(\$svcD.GetPropertyValue('startname') -match '${regex_username}'){exit 0}else{exit 1}",
    noop     => $noop,
  }
  File["${utensilsdll}"] -> Exec["Change credentials - $servicename"]
}