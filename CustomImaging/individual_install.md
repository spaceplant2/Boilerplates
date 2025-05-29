
# Installing Microsoft Windows
Creating the easiest I can make directions to reinstall windows for recovery purposes.

## Create the USB drive
[Ventoy](https://github.com/ventoy/Ventoy) is your best friend!
Download the Zip file [here](https://sourceforge.net/projects/ventoy/files/v1.0.99/ventoy-1.0.99-windows.zip/download), extract, and run Ventoy2Disk.exe -- with the USB plugged in to the computer, of course!

## Download the ISO
[tom's hardware walkthrough](https://www.tomshardware.com/how-to/clean-install-windows-11)

[Win11 ISO](https://www.microsoft.com/software-download/windows11)

[Win10 ISO](https://www.microsoft.com/en-us/software-download/windows10ISO)

- *Using Chrome* open your preferred link above.
- F12 to open developer mode
- CTRL+Shift+M to toggle device toolbar
  - This will allow you to tell the website you are using a device that you actually are not using
  - This causes the website to allow downloading of the ISO
- You should now see an option to download an ISO
- Select the multi-edition windows image and click download

## Load the USB

Copy the downloaded ISO onto the *large* partition that is on your USB

## Restart in Boot Menu
Spam function key at system power on.

for HP:
  - F9

for Dell:
  - F12

## Image the Computer

Select your USB, then select the appropriate windows image to boot from. The appropriate version should be selected based on the key stored in UEFI. When you have the option to select partitions, conventional wisdom says you should delete all partitions and then select 'New'. Or select partition #3, format it, select it again and delete it, then select 'New'. These approaches seem equivalent to me.

## Bypass Microsoft Account Creation

Once you reach an interactive prompt, you will want to take specific actions to avoid needing to access the Microsoft servers for login. There will be more than one restart which is expected- these generally occur without user interaction. When you reach the screen that asks for user telemetry, use the key combo *CTRL + Shift + F3* to bypass everything and load a desktop for the local administrator account. From here you can create the local account that you prefer, set the password that you want, and make any changes that you deem necessary.

## Create Local Account

https://answers.microsoft.com/en-us/windows/forum/all/how-to-create-a-local-account-in-windows-11/24c2e160-ac65-4748-a733-529e6507dfdf

## Important Notes

The local Administrator account will be disabled once this process is complete. Make sure that the account that you will use has been created before completing this process.

You will see a small window for the "System Preparation Tool". when you have finished with all your changes to the system, use the default settings:
- *Enter system Out-Of-Box_experience (OOBE)*
- generalize is *not* selected
- Shutdown Options set to *Reboot*
then click OK

## Completion

You will eventually get to the (normal) login screen, where you will use the login and password that was created during the *bypass microsoft account creation* phase.

## Finally

This is not final- if you find any issues with this process, you can start over from the beginning with impunity. Microsoft has acknowledged the imperative for reimaging computers on an unfettered basis. This is, and will be for the forseeable future, freely available to all.
