# == Class: windows_utensils
#
# This module allow you to manage system, network, service, and security features of Windows Servers >= 2008 easily
#
# === Module dscription
#
# Check to make sure Windows version is 2008 or greater
#
# === Parameters
#
#  None
#
# === Authors
#
# Michael Lucas (mike@lucasnet.org)
#
# === Copyright
#
# Copyright 2015 Michael Lucas, unless otherwise noted.
#
class windows_utensils::checkver {

  if $::kernel != 'windows' {
    fail('--> This module only works with Windows systems')
  }
  if versioncmp($::operatingsystemrelease, '6.1') < 0 {
    fail('--> Windows version is not supported...')
  }
  else {
    info('--> Operating System is Windows 2008 or newer.  Continuing...')
  }
}