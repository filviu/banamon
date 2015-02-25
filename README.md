BanaMon
=======

Bana = BASH, Mon = monitor. A simple BASH script to monitor a remote or local nagios instance and run custom commands depending on status. I use it to control a [BlinkStick](https://www.blinkstick.com/).
  
Personally I run it from cron on the same VM that's running nagios

    * * * * * /usr/local/bin/banamon.sh -f /usr/local/nagios/var/status.dat >/dev/null 2>&1


Usage
=====
```sh
Usage: banamon.sh -u nagios -p password -u http://www.example.com/nagios/cgi-bin/status.cgi

Options:
        -h, --help
                Print detailed usage information
        -U, --url
       		URL where nagios status is to be found
                (e.g. http://www.example.com/nagios/cgi-bin/status.cgi
        -u, --user
                Nagios username
        -p, --password
                Nagios password
        -f, --status
                Path to nagios status file, this excludes remote url access"

```
