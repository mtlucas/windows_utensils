# == Class: windows_utensils
#
# This module allow you to manage Windows service failure options
#
# === Parameters
#
#  Can be found on read me
#
# === Examples
#
#  windows_utensils::service_set_failure{'puppet':
#    servicename = "puppet",
#    failure_first_action = "restart",
#    failure_second_action = "restart",
#    failure_last_action = "reboot",
#    failure_delay = "10000",
#  }
# === Authors
#
# Michael Lucas (mike@lucasnet.org)
#
# === Copyright
#
# Copyright 2015 Michael Lucas, unless otherwise noted.
#
define windows_utensils::service_set_failure(
  $servicename   = '',
  $failure_first_action = 'restart',
  $failure_second_action = 'restart',
  $failure_last_action = 'restart',
  $failure_delay  = '60000',
)
{
  if(empty($servicename)){
    fail('Service name is mandatory')
  }
  if(empty($failure_first_action)){
    fail('Failure first action is optional, use <run|restart|reboot> values')
  }
  if(empty($failure_second_action)){
    fail('Failure second action is optional, use <run|restart|reboot> values')
  }
  if(empty($failure_last_action)){
    fail('Failure last action is optional, use <run|restart|reboot> values')
  }
  if(empty($failure_delay)){
    fail('Failure delay time is optional, in milliseconds')
  }
  $service_exists = "powershell get-service -name $servicename"

  exec{"Change Failure settings - $servicename":
    command     => "sc failure $servicename reset= 0 actions= $failure_first_action/$failure_delay/$failure_second_action/$failure_delay/$failure_last_action/$failure_delay",
    timeout     => 30,
    onlyif      => $service_exists,
  }
}