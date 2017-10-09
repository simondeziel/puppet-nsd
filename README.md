# Puppet NSD

Manages NSD server via Puppet.

## Requirements
* Ubuntu 16.04

## Usage

To run NSD with special options and host the slave zone `example.com` XFR'ed using TSIG:


```
  class { 'nsd':
    server_options => {
      'verbosity' => 2,
      'identity'  => 'foo',
    },
  }
  nsd::tsig { 'example.com-tsig':
    algorithm => 'hmac-sha512',
    secret    => 'zjdwFdIdeIta2cl2YMo0Y/dIKGC6Lx9LE9EdCpB8hO3mmMuqeToIubLREFk5rT6NK0rQ5MrXbZl+MoUUevESaw==',
  }
  nsd::zone { 'example.com':
    options => {
      'allow-notify' => ['192.0.2.53 example.com-tsig','192.0.2.54 example.com-tsig'],
      'request-xfr'  => ['192.0.2.53 example.com-tsig','192.0.2.54 example.com-tsig'],
    },
  }
```

To host the master zone `.` (aka the root zone) following RFC 7706:

```
  class { 'nsd': }
  nsd::zone { '.':
    options => {
      'request-xfr' => ['192.228.79.201 NOKEY',
                        '192.33.4.12 NOKEY',
                        '...FILL-ME...',
                        '2620:0:2d0:202::132 NOKEY'],
    }
  }
```

