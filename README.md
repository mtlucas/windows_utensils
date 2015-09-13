# windows_utensils

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with windows_utensils](#setup)
    * [Setup requirements](#setup-requirements)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Support - How contribute](#Support)

## Overview

Module allow us to manage complex windows settings using command line and Powershell executions.  Most of these modules are idempotent, 
however some will execute powershell each time they are executed.

 - Windows Firewall and IPv6 settings
 - Windows System settings like RDP and UAC (User access control)
 - Windows Services
 - Local Policy settings
 - Local User groups

## Module Description

Manage complex windows settings using command line tools and powershell.  Included resources:

 - windows_utensils::localgroup_add_user  -> Adds a user to a local group (including Domain users)
 - windows_utensils::network_firewall     -> Enables/disables Windows Firewall for all profiles
 - windows_utensils::network_ipv6         -> Enables/disables IPv6
 - windows_utensils::network_teredo       -> Enables/disables Teredo and IPv6 tunneling
 - windows_utensils::policy_set_privilege -> Add user to 'Logon as a Service' User right
 - windows_utensils::service_create       -> Create Windows service
 - windows_utensils::service_update       -> Update Windows service startup type and executable path
 - windows_utensils::service_set_failure  -> Set Windows service failure options
 - windows_utensils::service_credentials  -> Change Windows service credentials also adding SeServiceLogonRight to local policy rights
 - windows_utensils::service_delayedstart -> Change Windows service startup type to 'Automatic (Delayed)'
 - windows_utensils::service_description  -> Change Windows service description
 - windows_utensils::system_rdp           -> Enables/disables RDP
 - windows_utensils::system_uac           -> Enables/disables UAC (User access control)

Notes:  Delayed resource can't be applied without a server restart.

##Last Fix/Update
v 0.0.5 :
 - Add system_rdp, system_uac, network_firewall, network_ipv6, network_teredo resources and now check to make sure correct OS and version

v 0.0.4 :
 - Add description metaparamters to policy_set_privilege and localgroup_add_user in order to make them unique resources

v 0.0.3 :
 - Add service_description resource

v 0.0.2 :
 - Add service_create, service_update, service_set_failure, localgroup_add_user resources
 - Change names of resources to be more friendly
 
v 0.0.1 :
 - Add carbon.dll assembly. Permit to give privilege : SeServiceLogonRight to the specify account (useful for managing server without DC features)
 - Initial commit

 
## Setup

### Setup Requirements

Depends on the following modules:
['puppetlabs/stdlib', '>= 4.2.1'](https://forge.puppetlabs.com/puppetlabs/stdlib)
['puppetlabs/powershell', '>=1.0.5'](https://github.com/puppetlabs/puppetlabs-powershell),
['puppetlabs/registry', '>= 1.1.2'](https://github.com/puppetlabs/puppetlabs-registry.git)
['puppetlabs/reboot', '>= 1.1.0'](https://github.com/puppetlabs/puppetlabs-reboot.git)

Also requires that the Windows Server have powershell and .NET 4.5 installed


## Usage

**Resource: windows_utensils::network_firewall**
```
	windows_utensils::network_firewall{'Disable_Windows_Firewall':
	  ensure  => disabled,
	}
```
Parameters:
```
	$ensure            # Choices are <enabled,disabled,present,absent>
```


**Resource: windows_utensils::network_teredo**
```
	windows_utensils::network_teredo{'Disable_Teredo':
	  ensure  => disabled,
	}
```
Parameters:
```
	$ensure            # Choices are <enabled,disabled,present,absent>
```


**Resource: windows_utensils::network_ipv6**
```
	windows_utensils::network_ipv6{'Disable_IPv6':
	  ensure  => disabled,
	  state   => 'all',
	}
```
Parameters:
```
	$ensure            # Choices are <enabled,disabled,present,absent>
	$state             # OPTIONAL:  Choices are <all,preferred,nontunnel,tunnel>
```


**Resource: windows_utensils::service_create**
```
	windows_utensils::service_create{'puppet':
	  servicename      => "puppet",
	  service_exe_path => "C:\Program Files\Service\Service.exe",
	  service_startup  => "auto",
	}
```
Parameters:
```
	$servicename       # Short name of Windows service
	$service_exe_path  # Fully qualified path to service executable
	$service_startup   # Service startup value: <boot|system|auto|demand|disabled|delayed-auto>
```


**Resource: windows_utensils::service_update**
```
	windows_utensils::service_update{'puppet':
	  servicename      => "puppet",
	  service_exe_path => "C:\Program Files\Service\Service.exe",
	  service_startup  => "auto",
	}
```
Parameters:
```
	$servicename       # Short name of Windows service
	$service_exe_path  # Fully qualified path to service executable
	$service_startup   # OPTIONAL Service startup value: <boot|system|auto|demand|disabled|delayed-auto>
```


**Resource: windows_utensils::service_set_failure**
```
	windows_utensils::service_set_failure { 'puppetfailure':
	  servicename           => "puppet",
	  failure_first_action  => 'restart',
	  failure_second_action => 'restart',
	  failure_last_action   => 'restart',
	  failure_delay         => '60000',
	}
```
Parameters:
```
	$servicename           # Short name of Windows service
	$failure_first_action  # OPTIONAL First action of failure detection <run|restart|reboot>
	$failure_second_action # OPTIONAL Second action of failure detection <run|restart|reboot>
	$failure_last_action   # OPTIONAL Third action of failure detection <run|restart|reboot>
	$failure_delay         # OPTIONAL Delay time in milliseconds to perform failure action
	
```


**Resource: windows_utensils::service_delayedstart**
```
	windows_utensils::service_delayedstart{'puppetdelayed':
	  servicename => "puppet",
	}
```
Parameters:
```
	$servicename # Short name of Windows service
	$delayed     # OPTIONAL - Default True for put delayed start on service, set to false to let to automatic start
```


**Resource: windows_utensils:service_credentials**
```
	windows_utensils::service_credentials{'puppetcredentials':
	  servicename => "puppet",
	  username    => "DOMAIN\\User",
	  password    => "P@ssw0rd",
	}
```

Parameters:
```
	$servicename # Short name of Windows service
	$username    # Username to add to Windows service
	$password    # Password (use eYaml and hiera please)
```


**Resource: windows_utensils:service_description**
```
	windows_utensils::service_description{'puppetdesc':
	  servicename  => "puppet",
	  service_desc => "This is a Windows service description",
	}
```

Parameters:
```
	$servicename # Short name of Windows service
	$description # Windows service description using ASCII character
```


**Resource: windows_utensils:policy_set_privilege**
```
	windows_utensils::policy_set_privilege{'puppetuserpriv':
	  identity    => "DOMAIN\\User",
	  privilege   => "SeServiceLogonRight",
	}
```

Parameters:
```
	$identity    # Username to add to Logon As A Service User Right
	$privilege   # Unique Privilege name from Microsoft documentation
```


**Resource: windows_utensils:localgroup_add_user**
```
	windows_utensils::localgroup_add_user{'puppetadmin':
	  username    => "DOMAIN\\User",
	  group       => "Administrators",
	}
```

Parameters:
```
	$username   # Username to add to Windows Localgroup
	$group      # Local Group to add user to
```


**Resource: windows_utensils::system_rdp**
```
	windows_utensils::system_rdp{'Enable_RDP':
	  ensure  => enabled,
	}
```
Parameters:
```
	$ensure            # Choices are <enabled,disabled,present,absent>
```


**Resource: windows_utensils::system_uac**
```
	windows_utensils::system_uac{'Disable_UAC':
	  ensure  => disabled,
	}
```
Parameters:
```
	$ensure            # Choices are <enabled,disabled,present,absent>
```


## Limitations

Works only with Windows.  Each module will check to make sure the Windows version is supported (windows_utensils::checkver).
Tested on Windows Server 2012 R2 and Windows 2008 R2.
Carbon.dll v1.9.0.0 is included in order to add user identities to user rights.


License
-------
Apache License, Version 2.0

Contact
-------
[Michael Lucas](https://github.com/mtlucas)

Support
-------
Please log tickets and issues at [GitHub site](https://github.com/mtlucas/windows_utensils/issues)