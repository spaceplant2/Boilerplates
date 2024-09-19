# How it goes for me
Notes on Setting up Patchman from [Marcus Furlong](https://github.com/furlongm/patchman)

### My OS
I chose Debian 12 because Ubuntu 22.04 is being phased out in my environment. I do not have an actual issue with the other supproted distro's, there's just only so much space in my head for new info. Thusly, sticking with debisn-based is the only sensical option for me here.

### Quick Results
I am all about hitting it correctly the first time- and this is exactly where we landed! The server came up almost immediately (dely due to imaptience, dontcha know?). Follow the directions and you will be ok.

### Stylistic Observations
- The directions are written assuming that the user will be logged on with the root account. If you are not using root (and I highly suggest you *do not* enable root), make sure to replace all redirects `>` with `| sudo tee`. The files being written to are all controlled access. To silence the echoed output, append `> /dev/null` to the command. loggong on with user `root` was viable some time ago, but not so adviseable anymore.
- From the directions, it is implied that an Apache server will be needed. Using the repo handles this install and almost all configuration for you. The notable exception is that allowed hosts (or networks) will need to be added. I highly suggest using the repo's.
- 

## Hostname Configuration
This was fun to go through. It's been a long time since I've set up an apache server manually and there were quite a few things that had me stuck for a moment. The gist of it, however, is we need to make the hostname match throughout patchman *and* apache. So let's start with patchman!

In the file `/etc/patchman/patchman-client.conf` fix the hostname. I prefer to make it match what's in my DNS, but an IP is fine here if you are using a static. Notice that the client is using 443 to send statistics as this will be relevant to Apache configuration.
```
server=https://patchman.example.com
```
Now we head on over to `/etc/apache2/ports.conf` and add in a second listen statement under the currnet one.
```
Listen 80    #current statement
Listen 443   #add this statement
```
Lastly, we fix the hostname for the enabled site in `/etc/apache2/sites-enabled/000-default.conf` by uncommenting and changing the ServerName directive on line 9. Again, I like to make this match my dns records, but this is whatever you want to put in your browser's address bar to access patchman.
All that's left is to restart apache with `systemctl restart apache2` and test!
