###   build environment and launch program installers
#       This is intended to be genericised for public consumption
#       Copy of program-install.ps1, but pre-set to join domain for use from USB

function Select-ProgramGroups {
  <#
  .SYNOPSIS
    Select the desired groups of programs to install, this version for domain joining only

  .DESCRIPTION
    This function will walk through a list of selections to guide program installation. If no parameters are set, the questionnaire will engage.

  .PARAMETER Domain
    Set this parameter domain joining is needed

  .PARAMETER Rename
    Set this parameter if the computer needs to be renamed

  .PARAMETER Power
    Set this parameter to configure power policies

  .PARAMETER Programs
    Set this to install the basic program set

  .PARAMETER CAD
    Set this to install CAD programs

  .PARAMETER Cleanup
    Set this to run the cleanup process- GP update, Windows update, Dell Command update

  .PARAMETER Default
    Set Power, Programs, and Cleanup to run

  .EXAMPLE
    Select-ProgramGroups -Defaults

  .EXAMPLE
    Select-ProgramGroups -Domain -Rename
  #>
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [string]$Domain     = "y",
    [string]$Rename     = "n",
    [string]$Power      = "y",
    [string]$Programs   = "n",
    [String]$FreeCAD    = "n",
    [string]$CAD        = "n",
    [string]$FixProfile = "n",
    [string]$Cleanup    = "n",
    [Switch]$Defaults   = "n"
  )
  
  begin {
  # questionnaire lives here
    if ($Defaults){
      Write-Host "parameter defaults = $Defaults"
      $Power, $Programs, $Cleanup = $true
    } else {
      while ((-not $Domain) -or (($Domain -ne "y") -and ($Domain -ne "n"))) {
        $Domain = Read-Host -Prompt "Join computer to domain (y|n)? "
      }
      while ((-not $Rename) -or (($Rename -ne "y") -and ($Rename -ne "n"))) {
        $Rename = Read-Host -Prompt "Rename computer (y|n)? "
      }
      while ((-not $Power) -or (($Power -ne "y") -and ($Power -ne "n"))) {
        $Power = Read-Host -Prompt "Set power configuration (y|n)? "
      }
      while ((-not $Programs) -or (($Programs -ne "y") -and ($Programs -ne "n"))) {
        $Programs = Read-Host -Prompt "Install baseline programs (y|n)? "
      }
      while ((-not $FreeCAD) -or (($FreeCAD -ne "y") -and ($FreeCAD -ne "n"))) {
        $FreeCAD = Read-Host -Prompt "Install free CAD viewers (y|n)? "
      }
      while ((-not $CAD) -or (($CAD -ne "y") -and ($CAD -ne "n"))) {
        $CAD = Read-Host -Prompt "Install CAD programs (y|n)? "
      }
      while ((-not $FixProfile) -or (($FixProfile -ne "y") -and ($FixProfile -ne "n"))) {
        $FixProfile = Read-Host -Prompt "Set up user profile (y|n)? "
      }
      while ((-not $Cleanup) -or (($Cleanup -ne "y") -and ($Cleanup -ne "n"))) {
        $Cleanup = Read-Host -Prompt "Run post-install cleanup (y|n)? "
      }
    }
  }

  process {
#  iterate through the choices and launch the appropriate cmdlets
    if ( $domain -eq "y" ){
      Join-Domain
    }
    if ( $rename -eq "y" ){
      Change-ComputerName
    }
    if( $power -eq "y" ){
      Set-PowerPolicy
    }
    if( $programs -eq "y" ){
      OpenLicenseDocs
      CopySelfDeletingInstallers
      Install-Exe -Installers $exe_installers -LogPath $logFile
      Install-MSI -Installers $msi_installers -LogPath $logFile
    }
    if( $FreeCAD -eq "y" ){
      Install-Exe -Installers $freecad_exe_installers -LogPath $logFile
    }
    if( $CAD -eq "y" ){
      LaunchCadInstallers
    }
    if( $cleanup -eq "y" ){
      Invoke-Cleanup
      Install-WindowsUpdates
      Invoke-DellCommandUpdate
      # Enable-BitLockerAndBackup
    }
    if( $FixProfile -eq "y" ) {
      $group = Read-Host "What group is our user part of?"
      Add-QuickAccess -List $pin_items -Group $group -Action "pin"
      Mount-NetworkShares -SharesList $network_shares -Group $group
    }
  }

  end {
  }
}

###   Source all necessary files
#   load additional files
. .\global-vars.ps1
. .\manual-remediations.ps1
. .\install-vars.ps1
. .\install-funs.ps1

###   Then launch it
Select-ProgramGroups -Domain -Power
