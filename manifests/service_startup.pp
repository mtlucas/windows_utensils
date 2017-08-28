# == Class: windows_utensils
#
# This module allow you to update a Windows service startup
#
# === Parameters
#
#  Can be found on read me
#
# === Examples
#
#  windows_utensils::service_startup{'puppet':
#    servicename      => "puppet",
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
define windows_utensils::service_startup (
  $servicename   = '',
  $service_startup = 'auto',
)
{
  require windows_utensils::checkver

  if $noop == undef { $noop = false }

  if(empty($servicename)) {
    fail('--> servicename metaparameter is mandatory')
  }
  if(empty($service_startup)) {
    fail('--> service_startup metaparameter is required, use <boot|system|auto|demand|disabled|delayed-auto> values')
  }
  $service_exists = "C:\\Windows\\System32\\WindowsPowershell\\v1.0\\powershell.exe get-service -name ${servicename}"
  $service_update_startup = "C:\\Windows\\System32\\cmd.exe /C C:\\Windows\\System32\\sc.exe qc ${servicename} | find /I \"${service_startup}\""

  exec {"Update Service Startup - $servicename":
    command     => "C:\\Windows\\System32\\sc.exe config ${servicename} start= ${service_startup}",
    timeout     => 300,
    unless      => $service_update_startup,
    noop        => $noop,
  }
}
