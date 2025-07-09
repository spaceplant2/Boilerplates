# Acknowledgements
[github by Romel](https://gist.github.com/rpc180/bc3e39daac329ed4de146a43ed3bc73e)  
[On SuperUser](https://superuser.com/questions/1624231/how-to-create-an-unattended-windows-installation-medium-iso-usb-supporting-secur)

# Creating a custom image for Windows deployments

Quick notes for building a custom ISO. The process is basically the same for win10 and win11. Tools are available from Microsoft.
Some programs might need to be installed on the individual computers after this process is finished.

## The Tools
DISM lives in the system folder of windows installs
[Windows Assessment and Deployment Kit](https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install)
Deployment and Imaging Tools Environment

## Customized Image Work Flow
This is generally used to create an image with pre-installed programs. Security programs seem to not work well.
- acquire ISO image from Microsoft
- install on physical or virtual machine
- install required programs
- *clean all contents from C:\Windows\Panther*
- run sysprep and retrieve image

Check for the desired index location.
```
DISM /Get-WinInfo /WimFile:F:\sources\install.wim
```

Extract desired index.
```
DISM /Export-Image /SourceImageFile:F:\sources\install.wim /SourceIndex:2 /DestinationImageFile:D:\ISO\w11_Home.wim
```

From explorer, mount stock iso and copy all files to preferred working directory. This will provide working files for creating a new ISO.

mount image `sources\install.wim`
```
 dism /mount-image /imagefile:C:\image.wim /index:1 /mountdir:c:\mount
```

add Windows updates
```
Dism /Image:C:\mount\windows /Add-Package /PackagePath=windows10.0-kb4456655-x64.msu
```

inject drivers
```
dism /Image:C:\test\offline /Add-Driver /Driver:c:\drivers /Recurse
```

Copy your unattend.xml file to `C:\mount\Windows\Panther`

Autorun script lives at `C:\mount\boot\Windows\System32\startnet.cmd`. This can be useful for things like running Dell Commmand to set firmware settings

Clean up and image size reduction.
```
Dism /Image:C:\mount /cleanup-image /StartComponentCleanup /ResetBase
DISM.exe /Image:C:\mount /Optimize-Image /Boot
```

Then unmount the image and export it to a new file
```
Dism /Unmount-Image /MountDir:C:\mount /Commit
Dism /Export-Image /SourceImageFile:C:\Images\install.wim /SourceIndex:1 /DestinationImageFile:C:\Images\install_cleaned.wim
```

create ISO using files copied from stock ISO with custom WIM at `sources\install.wim`. Boot file might be at `\efi\boot\bootx64.efi` or `\efi\microsoft\boot\efisys.bin`

Open "Deployment and Imaging Tools Environments" command prompt as Administrator. The following will work with minor alterations to the actual paths.
```
oscdimg -m -o -u2 -udfver102 -bootdata:2#p0,e,b"C:\w11-extracted\boot\etfsboot.com"#pEF,e,b"C:\w11-extracted\efi\microsoft\boot\efisys.bin" "C:\w11-extracted" "C:\w11-automated.iso"
```

