# == Class: windows_utensils
#
# This module allow you to set a delayed start on a service
#
# === Parameters
#
#  Can be found on read me
#
# === Examples
#
#  windows_utensils::service_delayedstart{'puppet':
#    delayed     => true,
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
define windows_utensils::service_delayedstart (
  $delayed     = true,
  $servicename = '',
)
{
  require windows_utensils::checkver

  if $noop == undef { $noop = false }

  if(empty($servicename)) {
    fail('--> servicename metaparameter is mandatory')
  }

  if($delayed){
    $value = '1'
  }else{
    $value = '0'
  }

  exec {"Set Delayed_start - $servicename":
    command  => "New-ItemProperty -Path \"HKLM:\\System\\CurrentControlSet\\Services\\${servicename}\" -Name 'DelayedAutoStart' -Value '${value}' -PropertyType 'DWORD' -Force;",
    provider => "powershell",
    timeout  => 300,
    onlyif   => "if((test-path \"HKLM:\\System\\CurrentControlSet\\Services\\${servicename}\\\") -eq \$true){if((Get-ItemProperty -Path \"HKLM:\\System\\CurrentControlSet\\Services\\${servicename}\" -ErrorAction SilentlyContinue).DelayedAutoStart -eq '${value}'){exit 1;}else{exit 0;}}else{exit 1;}",
    noop     => $noop,
  }
}