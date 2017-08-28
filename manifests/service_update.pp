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
  $service_startup = 'auto',
  $service_exe_path = '',
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
  $service_exists = "C:\\Windows\\System32\\WindowsPowershell\\v1.0\\powershell.exe get-service -name ${servicename}"
  $service_update_exists = "C:\\Windows\\System32\\cmd.exe /C C:\\Windows\\System32\\sc.exe qc ${servicename} | find /I \"${service_exe_path}\""

  exec {"Update Service Exe - $servicename":
    command     => "C:\\Windows\\System32\\sc.exe config ${servicename} binPath= \"${service_exe_path}\"",
    timeout     => 300,
    unless      => $service_update_exists,
    noop        => $noop,
  }
}