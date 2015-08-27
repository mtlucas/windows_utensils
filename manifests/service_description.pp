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
#    servicename = "puppet",
#    service_desc = "Windows service description shown in Services MMC",
#  }
# === Authors
#
# Michael Lucas (mike@lucasnet.org)
#
# === Copyright
#
# Copyright 2015 Michael Lucas, unless otherwise noted.
#
define windows_utensils::service_description(
  $servicename   = '',
  $service_desc = '',
)
{
  if(empty($servicename)){
    fail('Service name is mandatory')
  }
  if(empty($service_desc)){
    fail('Service description is mandatory')
  }
  $service_exists = "powershell get-service -name $servicename"

  exec{"Set Service description - $servicename":
    command     => "sc description $servicename \"$service_desc\"",
    timeout     => 30,
    onlyif      => $service_exists,
  }
}