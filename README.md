BanaMon
=======

Bana = BASH, Mon = monitor. A simple BASH script to monitor a remote nagios instance and run custom commands depending on status. I use it to control a [BlinkStick](https://www.blinkstick.com/).

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
``
