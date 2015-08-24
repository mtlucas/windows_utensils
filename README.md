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

Module allow us to manage complex windows settings using command line and Powershell executions.

## Module Description

Manage complex windows settings using command line tools and powershell.  Included resources:

 - windows_utensils::credentials    -- Change Windows service credentials and adding SeServiceLogonRight local policy rights
 - windows_utensils::delayedstart   -- Change Windows service startup type to Automatic (Delayed)
 - windows_utensils::setpriv        -- Add user to SeServiceLogonRight local policy rights
 - windows_utensils::addusertogroup -- Adds a user to a local group

Delayed resource can't be applied without a server restart.

##Last Fix/Update
V 0.0.1 :
 - Add carbon.dll assembly. Permit to give privilege : SeServiceLogonRight to the specify account (useful for managing server without DC features)
 - Remove starting service from credentials resource

## Setup

### Setup Requirements

Depends on the following modules:
['puppetlabs/powershell', '>=1.0.2'](https://forge.puppetlabs.com/puppetlabs/powershell),
['puppetlabs/stdlib', '>= 4.2.1'](https://forge.puppetlabs.com/puppetlabs/stdlib)


## Usage

Resource: windows_utensils::service_create
```
	windows_utensils::service_create{'puppetdelayed':
	  servicename      => "puppet",
	  service_exe_path => "C:\Program Files\Service\Service.exe",
	  service_startup  => "auto",
	}
```
Parameters
```
	$servicename       # Short name of Windows service
	$service_exe_path  # Fully qualified path to service executable
	$service_startup   # Service startup value: <boot|system|auto|demand|disabled|delayed-auto>
```


Resource: windows_utensils::service_update
```
	windows_utensils::service_update{'puppetdelayed':
	  servicename      => "puppet",
	  service_exe_path => "C:\Program Files\Service\Service.exe",
	  service_startup  => "auto",
	}
```
Parameters
```
	$servicename       # Short name of Windows service
	$service_exe_path  # Fully qualified path to service executable
	$service_startup   # OPTIONAL Service startup value: <boot|system|auto|demand|disabled|delayed-auto>
```


Resource: windows_utensils::service_set_failure
```
	windows_utensils::service_set_failure { 'puppetfailure':
	  servicename           => "puppet",
	  failure_first_action  => 'restart',
	  failure_second_action => 'restart',
	  failure_last_action   => 'restart',
	  failure_delay         => '60000',
	}
```
Parameters
```
	$servicename           # Short name of Windows service
	$failure_first_action  # OPTIONAL First action of failure detection <run|restart|reboot>
	$failure_second_action # OPTIONAL Second action of failure detection <run|restart|reboot>
	$failure_last_action   # OPTIONAL Third action of failure detection <run|restart|reboot>
	$failure_delay         # OPTIONAL Delay time in milliseconds to perform failure action
	
```


Resource: windows_utensils::service_delayedstart
```
	windows_utensils::service_delayedstart{'puppetdelayed':
	  servicename => "puppet",
	}
```
Parameters
```
	$servicename # Short name of Windows service
	$delayed     # OPTIONAL - Default True for put delayed start on service, set to false to let to automatic start
```


Resource: windows_utensils:service_credentials
```
	windows_utensils::service_credentials{'puppetcredentials':
	  servicename => "puppet",
	  username    => "DOMAIN\\User",
	  password    => "P@ssw0rd",
	}
```

Parameters
```
	$servicename # Short name of Windows service
	$username    # Username to add to Windows service
	$password    # Password (use eYaml and hiera please)
```


Resource: windows_utensils:policy_set_privilege
```
	windows_utensils::policy_set_privilege{'puppetuserpriv':
	  identity    => "DOMAIN\\User",
	  privilege   => "SeServiceLogonRight",
	}
```

Parameters
```
	$identity    # Username to add to Logon As A Service User Right
	$privilege   # Privilege from Microsoft documentation (ex. SeServiceLogonRight)
```


Resource: windows_utensils:localgroup_add_user
```
	windows_utensils::localgroup_add_user{'puppetadmin':
	  username    => "DOMAIN\\User",
	  group       => "Administrators",
	}
```

Parameters
```
	$username   # Username to add to Windows Localgroup
	$group      # Local Group to add user to
```


## Limitations

Works only with windows.
Tested on Windows Server 2012 R2


License
-------
Apache License, Version 2.0

Contact
-------
[Michael Lucas](https://github.com/mtlucas)

Support
-------
Please log tickets and issues at [GitHub site](https://github.com/mtlucas/windows_utensils/issues)