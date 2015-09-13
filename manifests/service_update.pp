# == Class: windows_utensils
#
# This module allow you to update a Windows service, which can then be managed by puppet "service" resource
#
# === Parameters
#
#  Can be found on read me
#
# === Examples
#
#  windows_utensils::service_update{'puppet':
#    servicename      => "puppet",
#    service_exe_path => "C:\\Program Files\\Service\\Service.exe",
#    service_startup  => "auto",
#  }
# === Authors
#
# Michael Lucas (mike@lucasnet.org)
#
# === Copyright
#
# Copyright 2015 Michael Lucas, unless otherwise noted.
#
define windows_utensils::service_update (
  $servicename   = '',
  $service_exe_path = '',
  $service_startup = 'auto',
)
{
  require windows_utensils::checkver

  if(empty($servicename)) {
    fail('--> servicename metaparameter is mandatory')
  }
  if(empty($service_exe_path)) {
    fail('--> Fully qualified executable path is mandatory')
  }
  if(empty($service_startup)) {
    fail('--> service_startup metaparameter is optional, use <boot|system|auto|demand|disabled|delayed-auto> values')
  }
  $service_exists = "C:\\Windows\\System32\\WindowsPowershell\\v1.0\\powershell.exe get-service -name $servicename"

  exec {"Update Service - $servicename":
    command     => "C:\\Windows\\System32\\sc.exe config $servicename start= $service_startup binPath= \"$service_exe_path\"",
    timeout     => 300,
    onlyif      => $service_exists,
  }
}