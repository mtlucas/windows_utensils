# == Class: windows_utensils
#
# This module allow you to update a Windows service description
#
# === Parameters
#
#  Can be found on read me
#
# === Examples
#
#  windows_utensils::service_description{'puppet':
#    servicename  => "puppet",
#    service_desc => "Windows service description shown in Services MMC",
#  }
# === Authors
#
# Michael Lucas (mike@lucasnet.org)
#
# === Copyright
#
# Copyright 2015 Michael Lucas, unless otherwise noted.
#
define windows_utensils::service_description (
  $servicename   = '',
  $service_desc = '',
)
{
  require windows_utensils::checkver

  if $noop == undef { $noop = false }

  if(empty($servicename)) {
    fail('--> servicename metaparameter is mandatory')
  }
  if(empty($service_desc)) {
    fail('--> description metaparameter is mandatory')
  }
  $service_not_exists = "C:\\Windows\\System32\\WindowsPowershell\\v1.0\\powershell.exe if(\$ServiceTest = Get-Service $servicename -ErrorAction SilentlyContinue){Write-Host \"Service exists!\";Exit 1;}Else{Write-Host \"Service does NOT exist!\";Exit 0;}"
  $service_desc_exists = "C:\\Windows\\System32\\cmd.exe /C C:\\Windows\\System32\\sc.exe Qdescription $servicename | find /I \"$service_desc\""

  exec {"Set Service description - $servicename":
    command     => "C:\\Windows\\System32\\sc.exe description $servicename \"$service_desc\"",
	logoutput   => true,
    timeout     => 300,
    unless      => [$service_desc_exists, $service_not_exists],
    noop        => $noop,
  }
}