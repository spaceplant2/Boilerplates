# Powershell Program Installer

This needs only a little preparation before being useable. Places that will need editing:

## `global-vars.ps1`

This will contain paths that are specific to your environment. Use complete paths! This is fully capable of living on a network share adn running from there. Just be aware of permissions on the folder and keep in mind that the script needs administrator rights to install on the computer being prepped.

## `install-vars`

There are 2 basic installer types: msi, and exe. They take different option styles, so there are different functions to handle them. Copy and modify the appropriate structure in order to add a program for install. 

## Notes

You may have noticed references to a file `manual-remediations` that doesn't exist in this repository. I use this file to apply band-aids to my code to keep it functional as I develop it. This is necessary for me because I am creating this script as I find needs. This file generally contains whatever I need to keep the process moving - create the file and use as needed.