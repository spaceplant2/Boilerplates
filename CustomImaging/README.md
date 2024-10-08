# acknowledgements
https://gist.github.com/rpc180/bc3e39daac329ed4de146a43ed3bc73e

# Creating a custom image for Windows deployments

Quick notes for building a custom ISO. The process seems to be the same for win10 and win11

## The Tools
DISM lives in the system folder of windows installs
[Windows Assessment and Deployment Kit](https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install)
Deployment and Imaging Tools Environment

## Process Work Flow
acquire ISO image from microsoft
install on physical or virtual machine, install required programs
*clean all contents from C:\Windows\Panther*
run sysprep and retrieve image

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

Open "Deployment and Imaging Tools Environments" command prompt as Administrator

tryin g the boot file that sits next to the oscdimg executable
```
oscdimg -u2 -m -bC:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\efisys.bin" C:\isoContents C:\custom-win.iso
```

```
oscdimg.exe -m -o -u2 -udfver102 -bootdata:2#p0,e,b"C:\Users\mreed\Desktop\iso\win11-custom\win11Contents\boot\etfsboot.com"#pEF,e,b"C:\Users\mreed\Desktop\iso\win11-custom\win11Contents\efi\microsoft\boot\efisys.bin" "C:\Users\mreed\Desktop\iso\win11-custom\win11Contents" C:\Users\mreed\Desktop\iso\win11-custom\w11-all_drivers-20240815-bootfix.iso
```