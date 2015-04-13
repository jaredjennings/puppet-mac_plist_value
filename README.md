# Property lists in Mac OS X

This is a Puppet module that manages property lists under Mac OS
X. Some property lists are stored in files; some others are stored in
the directory service. Both locations are supported.

## Setting values in property lists in files

The file must exist, even if it is empty. You may need to use a file
resource to make sure the file will exist. This is so that you can be
sure of the ownership and permissions of a property list file that you
may be creating.

Examples:

```
    mac_plist_value { 'meaningless unique name with no colons':
	file => '/path/to/settings.plist',
	key => ['key', 'key2'],
	value => 3,
    }
    mac_plist_value { '/path/to/settings.plist:key/key2':
	value => 3,
    }
    mac_plist_value { '/path/to/settings.plist:key/key2':
	ensure => absent,
    }
    mac_plist_value { '/path/to/settings.plist:key':
	value => { 'key2' => 3, },
    }
    mac_plist_value { '/path/to/a.plist:key/*/otherkey':
	value => 3,
    }
    mac_plist_value { 'meaningless unique name w/o colons':
	file => '/path/to/a.plist',
	key => ['key', '*', 'otherkey'],
	value => 3,
    }
```

## Setting values in MCX property lists

Examples:

```
    mac_mcx_plist_value { 'meaningless but unique name':
	record => '/Computers/host1.example.com',
	key => ['com.example.app', 'mount-controls', 'dvd'],
	mcx_domain => 'always',
	value => { 'zap-sound' => 'blat' },
    }
    mac_mcx_plist_value { "/Computers/host1.example.com:\
	    com.example.app/mount-controls/dvd":
	value => 3,
    }
    mac_mcx_plist_value { 'meaningless unique 2':
	record => '/Computers/host1.example.com',
	key => ['com.example.app', 'mount-controls', 'dvd', 1],
	ensure => absent,
    }
```

## Mac OS X version compatibility

Just like [Gary Larizza's
`property_list_key`](https://forge.puppetlabs.com/glarizza/property_list_key),
q.v., this module started out dealing with property lists using
RubyCocoa, which was provided (at least) with Snow Leopard, then moved
to using CFPropertyList, which is provided (at least) with
Mavericks. Both means of property list editing still exist as separate
providers for the resource types given here.
