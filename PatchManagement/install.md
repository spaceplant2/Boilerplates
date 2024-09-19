# How it goes for me
Notes on Setting up Patchman from [Marcus Furlong](https://github.com/furlongm/patchman)

### My OS
I chose Debian 12 because Ubuntu 22.04 is being phased out in my environment. I do not have an actual issue with the other supproted distro's, there's just only so much space in my head for new info. Thusly, sticking with debisn-based is the only sensical option for me here.

### Quick Results
I am all about hitting it correctly the first time- and this is exactly where we landed! The server came up almost immediately (dely due to imaptience, dontcha know?). Follow the directions and you will be ok.

### Stylistic Observations
- The directions are written assuming that the user will be logged on with the root account. If you are not using root, make sure to replace all redirects `>` with `| sudo tee`. The files being written to are all controlled access. To silence the echoed output, append `> /dev/null` to the command. loggong on with user `root` was viable some time ago, but not so adviseable anymore.
- From the directions, it is implied that an Apache server will be needed. Using the repo handles this install and almost all configuration for you. The notable exception is that allowed hosts (or networks) will need to be added. I highly suggest using the repo's.
- 

## Next Thoughts
Getting this server properly set to do its work is going to be an actual learning experience. I am going to have to learn about different mirrors for different distros. 
