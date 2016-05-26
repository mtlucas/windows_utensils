# == Class: windows_utensils
#
# This module allow you to create a Windows service, which can then be managed by puppet "service" resource
#
# === Parameters
#
#  $service_displayname is OPTIONAL and will default to $servicename
#
# === Examples
#
#  windows_utensils::service_create{'puppet':
#    servicename      => 'pe-puppet',
#    service_exe_path => "C:\\Program Files\\Service\\Service.exe",
#    service_startup  => 'auto',
#    service_displayname  => 'pe-puppet',
#  }
# === Authors
#
# Michael Lucas (mike@lucasnet.org)
#
# === Copyright
#
# Copyright 2015 Michael Lucas, unless otherwise noted.
#
define windows_utensils::service_create (
  $servicename   = '',
  $service_exe_path = '',
  $service_startup = 'auto',
  $service_displayname = '',
)
{
  require windows_utensils::checkver

  if $noop == undef { $noop = false }

  if(empty($servicename)) {
    fail('--> servicename metaparameter is mandatory')
  }
  if(empty($service_exe_path)) {
    fail('--> Fully qualified executable path is mandatory')
  }
  if(empty($service_startup)) {
    fail('--> service_startup metaparameter is optional, use <boot|system|auto|demand|disabled|delayed-auto> values')
  }
  if(empty($service_displayname)) {
    $service_display_name = $servicename
  }
  else {
    $service_display_name = $service_displayname
  }
  $service_exists = "C:\\Windows\\System32\\WindowsPowershell\\v1.0\\powershell.exe get-service -name $servicename"
  $service_exe_exists = "C:\\Windows\\System32\\WindowsPowershell\\v1.0\\powershell.exe if(test-path $service_exe_path){Write-Host \"Service EXE exists!\";Exit 1;}Else{Write-Host \"Service EXE does NOT exist!\";Exit 0;}"
  
  exec {"Create Service - $servicename":
    command     => "C:\\Windows\\System32\\sc.exe create $servicename displayname= \"$service_display_name\" start= $service_startup binPath= \"$service_exe_path\"",
	logoutput   => true,
    timeout     => 300,
    unless      => [$service_exists, $service_exe_exists],
    noop        => $noop,
  }
}