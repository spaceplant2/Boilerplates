# How it goes for me
Notes on Setting up Patchman from [Marcus Furlong](https://github.com/furlongm/patchman)

### My OS
I chose Debian 12 because Ubuntu 22.04 is being phased out in my environment.

### Stylistic Observations
The directions are written assuming that the user will be logged on with the root account. If you are not using root, make sure to replace all redirects `>` with `| sudo tee`. The files being written to are all controlled access. To silence the echoed output, append `> /dev/null` to the command.

From the directions, it is implied that an Apache server will be needed. Using the repo handles this install and almost all configuration for you. The notable exception is that allowed hosts (or networks) will need to be added. I highly suggest using the repo's.

## Next Thoughts
Getting this server properly set to do its work is going to be an actual learning experience. I am going to have to learn about different mirrors for different distros. 
