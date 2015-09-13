# == Class: windows_utensils
#
# This module allow you to manage Add a Domain user to localgroup
#
# === Parameters
#
#  Can be found on read me
#
# === Examples
#
#  windows_utensils::localgroup_add_user{'puppet':
#    username    => "DOMAIN\\User",
#    group       => "LocalGroup",
#    description => "Unique description",
#  }
# === Authors
#
# Michael Lucas (mike@lucasnet.org)
#
# === Copyright
#
# Copyright 2015 Michael Lucas, unless otherwise noted.
#
define windows_utensils::localgroup_add_user (
  $username    = '',
  $group       = '',
  $description = '',
)
{
  require windows_utensils::checkver

  if(empty($username)) {
    fail('--> username metaparameter is mandatory')
  }
  if(empty($group)) {
    fail('--> group metaparameter is mandatory')
  }
  if(empty($description)) {
    fail('--> description metaparameter is mandatory in order to make this resource unique')
  }
  
  exec {"Add User to LocalGroup - $description":
    command  => "C:\\Windows\\System32\\net.exe localgroup $group $username /add",
    timeout  => 300,
	  unless   => "C:\\Windows\\system32\\cmd.exe /C net.exe localgroup $group | find /I \"$username\"",
  }
}