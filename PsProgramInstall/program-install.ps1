###   build environment and launch program installers
#       This is intended to be genericised for public consumption

#   load additional files
. .\global-vars.ps1
. .\manual-remediations.ps1
. .\install-vars.ps1
. .\install-funs.ps1


function Select-ProgramGroups {
  <#
  .SYNOPSIS
    Select the desired groups of programs to install

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
    [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
    [switch]$Domain

    [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
    [switch]$Rename

    [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
    [switch]$Power

    [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
    [switch]$Programs

    [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
    [switch]$CAD

    [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
    [switch]$Cleanup

    [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
    [switch]$Defaults
  )
  
  begin {
# questionnaire lives here
    if ($Defaults){
      $Power, $Programs, $Cleanup = $true
    }else {
      while (-not $Domain) {
        $Domain = Read-Host -Prompt "Join computer to domain (y|n)? "
      }
      while (-not $Rename) {
        $Rename = Read-Host -Prompt "Rename computer (y|n)? "
      }
      while (-not $Power) {
        $Power = Read-Host -Prompt "Set power configuration (y|n)? "
      }
      while (-not $Programs) {
        $Programs = Read-Host -Prompt "Install baseline programs (y|n)? "
      }
      while (-not $CAD) {
        $CAD = Read-Host -Prompt "Install CAD programs (y|n)? "
      }
      while (-not $Cleanup) {
        $Cleanup = Read-Host -Prompt "Run post-install cleanup (y|n)? "
      }
    }
  }

  process {
# iterate through the choices and launch the appropriate cmdlets
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
      Install-MSI $msi_installers
    }
    if( $cad -eq "y" ){
      LaunchCadInstallers
    }
    if( $cleanup -eq "y" ){
      Invoke-Cleanup
      Install-WindowsUpdates
      Invoke-DellCommandUpdate
      # Enable-BitLockerAndBackup
    }
  }

  end {
  }
}