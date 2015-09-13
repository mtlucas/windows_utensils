# == Class: windows_utensils
#
# This module adds teh Carbon.dll file needed for some security operations
#
# === Parameters
#
#  Can be found on read me
#
# === Examples
#
#  require windows_utensils::carbon_file
#  $utensilsdll = $windows_utensils::carbon_file::utensilsdll
#
# === Authors
#
# Michael Lucas (mike@lucasnet.org)
#
# === Copyright
#
# Copyright 2015 Michael Lucas, unless otherwise noted.
#
class windows_utensils::carbon_file {

  $utensilsdll = "C:\\windows\\carbon.dll"
  
  file {"${utensilsdll}":
    source             => "puppet:///modules/windows_utensils/Carbon.dll",
    source_permissions => ignore,
  }
}