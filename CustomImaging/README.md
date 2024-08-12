# Creating a custom image for Windows deployments

Quick notes for building a custom ISO. The process seems to be the same for win10 and win11

## The Tools
DISM lives in the system folder of windows installs
[Windows Assessment and Deployment Kit](https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install)
Deployment and Imaging Tools Environment

## Process Work Flow
acquire image from microsoft
install on physical or virtual machine, install required programs
run sysprep and retrieve image
mount iso, and copy all files to preferred working directory
mount image `sources\install.wim`

inject drivers
```
Dism /Image:C:\test\offline /Add-Driver /Driver:c:\drivers /Recurse
```

dismount image and commit changes

create ISO using files copied from stock ISO with custom WIM at sources\install.wim
```
oscdimg -u2 -m -bC:\boot\bootfix.bin C:\isoContents C:\custom-win.iso
```
try using -j2 option instead of -u2