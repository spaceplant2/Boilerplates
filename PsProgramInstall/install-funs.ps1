###   Installer functions

function Write-Log {
  <#
  .SYNOPSIS
    Writes messages to a log file and console output with timestamps.
  
  .DESCRIPTION
    This function handles logging to both console and file with consistent formatting.
    It supports multiple message types (information, warnings, errors) and can create
    new log files or append to existing ones.
  
  .PARAMETER Message
    The message to be logged.
  
  .PARAMETER Level
    The severity level of the message (Info, Warning, Error).
  
  .PARAMETER LogPath
    The path to the log file. If not specified, uses a default location.
  
  .PARAMETER NoConsoleOut
    Suppresses console output (logs to file only).
  
  .PARAMETER Component
    Optional component name to identify the source of the message.
  
  .EXAMPLE
    Write-Log -Message "Starting installation" -Level Info
      
  .EXAMPLE
    Write-Log -Message "File not found" -Level Warning -Component "Installer"
      
  .EXAMPLE
    Write-Log -Message "Critical error occurred" -Level Error -LogPath "C:\Logs\script.log"
  #>
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [string]$Message,
    
    [Parameter()]
    [ValidateSet('Info','Warning','Error')]
    [string]$Level = 'Info',
    
    [Parameter()]
    [string]$LogPath,
    
    [Parameter()]
    [switch]$NoConsoleOut,
    
    [Parameter()]
    [string]$Component = ''
  )
  
  begin {
    # Set default log path if not specified
    if (-not $LogPath) {
      $LogPath = if ($LogPathPreset) {$LogPathPreset} else {"$env:TEMP"}
      # Write-Host "Setting var LogPath to $LogPath" -ForegroundColor Blue
    }
    # Create log directory if it doesn't exist
    $logDir = Split-Path -Path $LogPath -Parent
    if (-not (Test-Path -Path $logDir)) {
      # Write-Host "Creating log directory at $logDir" -ForegroundColor Blue
      New-Item -ItemType "Directory" -Path $logDir -Force | Out-Null
    }
    # Create log file
    $logFile = "$(Get-Date -Format 'yyyyMMdd')_$($env:COMPUTERNAME).log"
    if (-not (Test-Path -Path "$LogPath\$logFile" -PathType Leaf)) {
      # Write-Host "Creating Log file $logFile" -ForegroundColor Blue
      New-Item -ItemType "File" -Path "$LogPath\$logFile" -Force | Out-Null
    }
  }
  
  process {
    # Create timestamp
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"
    # Format the message
    if ($Component) {
      $logMessage = "[$timestamp][$Level][$Component] $Message"
    } else {
      $logMessage = "[$timestamp][$Level] $Message"
    }
    # Write to log file
    try {
      # Write-Host "Adding message to log"  -ForegroundColor Blue
      Add-Content -Path "$LogPath\$logFile" -Value $logMessage -Encoding utf8 -ErrorAction Stop
    }
    catch {
      Write-Error "Failed to write to log file: $_"
    }
    
    # Write to console unless suppressed
    if (-not $NoConsoleOut) {
      switch ($Level) {
        'Info' { Write-Host $logMessage -ForegroundColor Green }
        'Warning' { Write-Host $logMessage -ForegroundColor Yellow }
        'Error' { Write-Host $logMessage -ForegroundColor Red }
      }
    }
  }
  
  end {
    # Cleanup if needed
  }
}

function Join-Domain {
  <#
  .SYNOPSIS
    Joins the computer to a domain and renames it using site abbreviation and serial number.
  
  .DESCRIPTION
    This cmdlet joins the computer to a specified domain, generates a new name based on site abbreviation
    and BIOS serial number, and performs the rename operation with an automatic restart.
  
  .PARAMETER SiteAbbreviation
    The site abbreviation to prepend to the serial number
  
  .PARAMETER DomainName
    The fully qualified domain name to join
  
  .PARAMETER DomainCredential
    Credential for domain join operation
  
  .PARAMETER LogPath
    Optional path for log file
  
  .EXAMPLE
    Join-Domain -DomainName "domain.com" -DomainCredential (Get-Credential)
  
  .EXAMPLE
    Join-Domain -SiteAbbreviation "HQ" -DomainName "domain.com" -DomainCredential "domain\admin" -LogPath C:\Logs\domainjoin.log
  #>
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [Parameter(Mandatory = $false)]
    [string]$SiteAbbreviation,
    
    [Parameter(Mandatory = $false)]
    [string]$DomainName,
    
    [Parameter(Mandatory = $false)]
    [string]$DomainCredential,
    
    [string]$LogPath
  )

  begin {
    Write-Log "=== Domain Join Process Started ===" -LogPath $LogPath
    $oldName = $env:COMPUTERNAME
    Write-Log "Current computer name: $oldName" -LogPath $LogPath

    # Get site abbreviation if not provided
    if (-not $PSBoundParameters.ContainsKey('SiteAbbreviation')) {
      $SiteAbbreviation = Read-Host "What site abbreviation are you using?"
      Write-Log "User provided site abbreviation: $SiteAbbreviation" -LogPath $LogPath
    }
    if (-not $PSBoundParameters.ContainsKey('SiteAbbreviation')) {
      $DomainName = Read-Host "What is the domain we are joining?"
      Write-Log "User provided domain $DomainName" -LogPath $LogPath
    }
    if (-not $PSBoundParameters.ContainsKey('DomainCredential')) {
      $ok = "n"
      while ($ok -ne "y"){
        # $DomainCredential = $DomainName.Split(".")[0]
        $username += Read-Host "What is the username we will use?"
        $fullCredential = "$($DomainName.Split(".")[0])\$username"
        $ok = Read-Host "using $fullCredential, is this correct?"
        if ($ok -eq "y") {
          $DomainCredential = $fullCredential
        }
      }
    }

    # Generate new name
    $serialNumber = (Get-WmiObject -Class win32_bios).SerialNumber
    $newName = "$SiteAbbreviation-$serialNumber".ToUpper()
    
    Write-Log "Generated computer name will be: $newName" -LogPath $LogPath -Level Info

  }

  process {
    try {
      if ($PSCmdlet.ShouldProcess("Domain join", "Join computer '$oldName' to domain '$DomainName' as '$newName'")) {
        Add-Computer -ComputerName $oldName -NewName $newName -DomainName $DomainName -Credential $DomainCredential -Verbose -Restart -Force -ErrorAction Stop
        Write-Log "Successfully joined domain '$DomainName'. Computer will restart with new name '$newName'" -LogPath $LogPath
      }
    }
    catch {
      Write-Log "Failed to join domain: $_" -LogPath $LogPath -Level Error
      $failError = $_
      throw
    }
  }

  end {
    Write-Log "=== Domain Join Process Completed, sending restart signal ===" -LogPath $LogPath
    # if ((-not $failError) -or ($failError -eq "")) {
    #   shutdown -r -t 0
    # }
  }
}

function Change-ComputerName {
  <#
  .SYNOPSIS
    Renames the computer using a site abbreviation and the BIOS serial number.
  
  .DESCRIPTION
    This cmdlet prompts for a site abbreviation, combines it with the system's serial number,
    and renames the computer with an automatic restart.
  
  .PARAMETER SiteAbbreviation
    The site abbreviation to prepend to the serial number
  
  .PARAMETER LogPath
    Optional path for log file
  
  .EXAMPLE
    Set-ComputerName
  
  .EXAMPLE
    Set-ComputerName -SiteAbbreviation "NYC"
  #>
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [Parameter(Mandatory = $false)]
    [string]$SiteAbbreviation,
    
    [string]$LogPath
  )

  begin {
    Write-Log "=== Computer Rename Process Started ===" -LogPath $LogPath
  }

  process {
    try {
      # Get site abbreviation if not provided
      if (-not $PSBoundParameters.ContainsKey('SiteAbbreviation')) {
        $SiteAbbreviation = (Read-Host "What site abbreviation are you using?").ToUpper()
        Write-Log "User provided site abbreviation: $SiteAbbreviation" -LogPath $LogPath
      }

      # Get serial number
      $serialNumber = (Get-WmiObject -Class win32_bios).SerialNumber
      $newName = "$SiteAbbreviation-$serialNumber"
      
      Write-Log "New computer name will be: $newName" -LogPath $LogPath

      if ($PSCmdlet.ShouldProcess("Computer name", "Change to '$newName' with restart")) {
        Rename-Computer -NewName $newName -Restart -Force
        Write-Log "Computer rename initiated. System will restart." -LogPath $LogPath
      }
    }
    catch {
        Write-Log "Failed to rename computer: $_" -LogPath $LogPath -Level Error
        throw
    }
  }

  end {
    Write-Log "=== Computer Rename Process Completed ===" -LogPath $LogPath
  }
}

###   Set power policy
function Set-PowerPolicy {
  <#
  .SYNOPSIS
    Configures system power settings and display rotation policies with comprehensive logging.
  
  .DESCRIPTION
    This cmdlet applies power settings with the assumption of administrative privileges.
    Features include:
    - Sets power scheme to "Ultimate Performance" (falls back to "High Performance")
    - Configures standby and monitor timeouts
    - Disables auto-rotation
    - Detailed logging via Write-Log
  
  .PARAMETER MonitorTimeoutAC
    Minutes before monitor turns off on AC power (default: 15)
  
  .PARAMETER MonitorTimeoutDC
    Minutes before monitor turns off on battery (default: 10)
  
  .PARAMETER DisableAutoRotation
    Disables screen auto-rotation (default: $true)
  
  .PARAMETER LogPath
    Optional path for log file (defaults to Write-Log's default location)
  
  .EXAMPLE
    Set-PowerPolicy
    Applies default power settings with logging
  
  .EXAMPLE
    Set-PowerPolicy -MonitorTimeoutAC 30 -MonitorTimeoutDC 15 -LogPath C:\Logs\powerconfig.log
    Applies custom timeouts with specific log location
  #>
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [int]$MonitorTimeoutAC = 15,
    [int]$MonitorTimeoutDC = 10,
    [bool]$DisableAutoRotation = $true,
    [string]$LogPath
  )

  begin {
    $ultimatePerfGuid = '381b4222-f694-41f0-9685-ff5bb260df2e'
    $highPerfGuid = '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'
    Write-Log "=== Power Policy Configuration Started ===" -LogPath $LogPath
    Write-Log "Parameters: AC Timeout=$MonitorTimeoutAC, DC Timeout=$MonitorTimeoutDC, DisableRotation=$DisableAutoRotation" -LogPath $LogPath
  }

  process {
    try {
      # Set power scheme
      if ($PSCmdlet.ShouldProcess("Power scheme", "Set")) {
        $schemes = powercfg /L
        if ($schemes -match $ultimatePerfGuid) {
          powercfg /S $ultimatePerfGuid
          Write-Log "Set power scheme to Ultimate Performance" -LogPath $LogPath
        }
        else {
          powercfg /S $highPerfGuid
          Write-Log "Set power scheme to High Performance (Ultimate not available)" -LogPath $LogPath -Level Warning
        }
      }

      # Configure power timeouts
      if ($PSCmdlet.ShouldProcess("Power timeouts", "Configure")) {
        powercfg -change -standby-timeout-ac 0
        powercfg -change -standby-timeout-dc 0
        powercfg -change -monitor-timeout-ac $MonitorTimeoutAC
        powercfg -change -monitor-timeout-dc $MonitorTimeoutDC
        Write-Log "Configured power timeouts: Standby=disabled, Monitor AC=$MonitorTimeoutAC, DC=$MonitorTimeoutDC" -LogPath $LogPath
      }

      # Configure auto-rotation
      if ($DisableAutoRotation -and $PSCmdlet.ShouldProcess("Auto-rotation", "Disable")) {
        try {
          $regPath = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AutoRotation"
          Set-ItemProperty -Path "$regPath" -Name "LastOrientation" -Value 0 -Force -ErrorAction SilentlyContinue
          Set-ItemProperty -Path "$regPath" -Name "Enable" -Value 0 -Force -ErrorAction SilentlyContinue
          Write-Log "Disabled screen auto-rotation" -LogPath $LogPath
        }
        catch {
          Write-Log "Failed to disable auto-rotation: $_" -LogPath $LogPath -Level Error
        }
      }
    }
    catch {
      Write-Log "Power configuration failed: $_" -LogPath $LogPath -Level Error
      throw
    }
  }

  end {
    Write-Log "=== Power Policy Configuration Completed ===" -LogPath $LogPath
  }
}

function Install-MSI {
  <#
  .SYNOPSIS
    Installs multiple MSI packages with detailed logging and status reporting.
  
  .DESCRIPTION
    Processes an array of installer objects to install MSI packages sequentially.
    Provides comprehensive logging, exit code handling, and performance tracking.
  
  .PARAMETER Installers
    Array of custom objects containing MSI installation details. Each object should have:
    - Name: Display name of the application
    - Action: MSI action (typically /i for install or /x for uninstall)
    - Path: Full path to the MSI file
    - Args: Additional command line arguments
  
  .PARAMETER LogPath
    Optional path to save the installation log file
  
  .EXAMPLE
    $installers = @(
        [PSCustomObject]@{
            Name = "App1"
            Action = "/i"
            Path = "C:\installers\app1.msi"
            Args = "/quiet"
        }
    )
    Install-MSI -Installers $installers
  
  .NOTES
    Requires administrative privileges for MSI installations.
    Uses Write-Log function for logging.
  #>
  [CmdletBinding()]
  param(
      [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
      [array]$Installers,
      
      [string]$LogPath
  )

  begin {
    Write-Log "=== Installation Process Started ==="
  }
  process {
    foreach ($installer in $installers) {
    $startTime = Get-Date
    Write-Log "Starting installation: $($installer.Name)" -NoConsoleOut
    Write-Log "Command: msiexec.exe $($installer.Action) `"$($installer.Path)`" $($installer.Args)" -NoConsoleOut
    
      try {
        if( (! $installer.Args) -or ($installer.Args -eq "") ){
          $process = Start-Process -FilePath "msiexec.exe" -ArgumentList $installer.Action, "`"$($installer.Path)`"" -NoNewWindow -PassThru -Wait -ErrorAction Stop
        }else{
          $process = Start-Process -FilePath "msiexec.exe" -ArgumentList $installer.Action, "`"$($installer.Path)`"", $installer.Args -NoNewWindow -PassThru -Wait -ErrorAction Stop
        }
        
        $exitCode = $process.ExitCode
        $duration = (Get-Date) - $startTime
        
        if ($exitCode -eq 0) {
          Write-Log "SUCCESS: $($installer.Name) installed successfully (Exit Code: $exitCode, Duration: $($duration.TotalSeconds) seconds)" -NoConsoleOut
        }
        else {
          Write-Log "WARNING: $($installer.Name) installation completed with exit code $exitCode (Duration: $($duration.TotalSeconds) seconds)"
          # Add MSI-specific error interpretation if needed
          $errorMessage = switch ($exitCode) {
            1603 { "Fatal error during installation" }
            1618 { "Another installation already in progress" }
            1638 { "Incompatible version already installed" }
            default { "Unknown error" }
          }
          Write-Log "ERROR DETAILS: $errorMessage"
        }
      } catch {
        Write-Log "ERROR: Failed to install $($installer.Name)"
        Write-Log "EXCEPTION: $($_.Exception.Message)"
        $exitCode = -1
      }
    }  
    # Add to summary
    $installer | Add-Member -NotePropertyName "ExitCode" -NotePropertyValue $exitCode
    $installer | Add-Member -NotePropertyName "Status" -NotePropertyValue $(if ($exitCode -eq 0) { "Success" } else { "Failed" })
    $installer | Add-Member -NotePropertyName "Duration" -NotePropertyValue $duration
  }

  end {
    # Generate summary report
    Write-Log "`n=== Installation Summary ==="
    $installers | ForEach-Object {
      # Write-Log "$($_.Name.PadRight(15)) - $($_.Status.PadRight(7)) - Exit Code: $($_.ExitCode) - Duration: $([math]::Round($_.Duration.TotalSeconds,2))s"
      if ($_.Name){
        Write-Log "$($_.Name) - $($_.Status) - Exit Code: $($_.ExitCode) - Duration: $([math]::Round($_.Duration.TotalSeconds,2))s"
      }
    }

    # Save log to file
    $log | Out-File -FilePath $logFile -Force
    Write-Log "`nLog file saved to: $logFile"

    # Optionally display log path
    Invoke-Item $logFile
  }
}

function Install-EXE {
  <#
  .SYNOPSIS
    Installs multiple EXE packages with detailed logging and status reporting.
  
  .DESCRIPTION
    Processes an array of installer objects to install EXE packages sequentially.
    Handles both silent and interactive installations with comprehensive logging.
    Copies specific installers locally before execution and provides reboot awareness.
  
  .PARAMETER Installers
    Array of custom objects containing EXE installation details. Each object should have:
    - Name: Display name of the application
    - Path: Full path to the EXE file
    - Args: Command line arguments for silent installation
    - ValidExitCodes: Array of acceptable exit codes (default: @(0))
  
  .PARAMETER LogPath
    Optional path to save the installation log file
  
  .EXAMPLE
    $installers = @(
        [PSCustomObject]@{
            Name = "App1"
            Path = "C:\installers\app1.exe"
            Args = "/silent"
            ValidExitCodes = @(0, 3010)
        }
    )
    Install-EXE -Installers $installers -Server "\\fileserver\install"
  
  .NOTES
    Requires administrative privileges for most installations.
    Uses Write-Log function for comprehensive logging.
    Handles exit code 3010 (reboot required) specially.
  #>
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [array]$Installers,
    
    [string]$LogPath
  )

  begin {
    Write-Log "=== Installation Process Started ==="
  }

  process {
    foreach ($installer in $installers) {
      $startTime = Get-Date
      Write-Log "Starting installer: $($installer.Name)" -NoConsoleOut
      Write-Log "Command: `"$($installer.Path)`" $($installer.Args)" -NoConsoleOut
      
      try {
        if ( $installers.Args -ne "" ) {
          $process = Start-Process -FilePath $installer.Path -ArgumentList $installer.Args -NoNewWindow -PassThru
        }elseif ((! $installers.Args ) -or ( $installers.Args -eq "" )) {
          $process = Start-Process -FilePath $installer.Path -NoNewWindow -PassThru
        }
        $process | Wait-Process -Timeout 300 -ErrorAction Stop -ErrorVariable timedOut
        $exitCode = $process.ExitCode
        $duration = (Get-Date) - $startTime
        
        if ($timedout) {
          Write-Log "Installer timed out - forcing termination of $process"
          Kill-Installer -ProcessName $process.ProcessName
        }
        if ($installer.ValidExitCodes -contains $exitCode) {
          $status = switch ($exitCode) {
              3010 { "SUCCESS (Reboot Required)" }
          }
          Write-Log "$status - $($installer.Name) installed successfully (Exit Code: $exitCode, Duration: $($duration.TotalSeconds) seconds)" -NoConsoleOut
        } else {
          Write-Log "ERROR: $($installer.Name) installation failed (Exit Code: $exitCode, Duration: $($duration.TotalSeconds) seconds)"
          # Add common EXE error interpretation
          $errorMessage = switch ($exitCode) {
              1 { "Incorrect parameters" }
              2 { "Missing files" }
              3 { "Reboot required before installation" }
              4 { "Another installation in progress" }
              5 { "Access denied" }
              1602 { "Already Installed" }
              1603 { "Already Installed" }
              default { "Unknown error" }
          }
          Write-Log "ERROR DETAILS: $errorMessage"
        }
      }
      catch {
          Write-Log "ERROR: Failed to install $($installer.Name)"
          Write-Log "EXCEPTION: $($_.Exception.Message)"
          $exitCode = -1
      }
      # Add to summary
      $installer | Add-Member -NotePropertyName "ExitCode" -NotePropertyValue $exitCode -Force
      $installer | Add-Member -NotePropertyName "Status" -NotePropertyValue $(if ($installer.ValidExitCodes -contains $exitCode) { "Success" } else { "Failed" }) -Force
      $installer | Add-Member -NotePropertyName "Duration" -NotePropertyValue $duration -Force
    }
  }

  end {
    # Generate summary report
    Write-Log "`n=== Installation Summary ==="
    $installers | ForEach-Object {
      $statusDisplay = if ($_.ExitCode -eq 3010) { "Success*" } else { $_.Status }
      Write-Log "$($_.Name.PadRight(20)) - $($statusDisplay.PadRight(8)) - Exit Code: $($_.ExitCode.ToString().PadRight(4)) - Duration: $([math]::Round($_.Duration.TotalSeconds,2))s"
    }
    if ($installers.ExitCode -contains 3010) {
      Write-Log "`n* Note: Exit code 3010 indicates a reboot is required"
    }

    # Save log to file
    $log | Out-File -FilePath $logFile -Force
    Write-Log "`nLog file saved to: $logFile"

    # Optionally display log path
    Invoke-Item $logFile
  }
}

function Kill-Installer {
  <#
  .SYNOPSIS
    Terminates stubborn installer processes that fail to exit after completion.

  .DESCRIPTION
    Safely terminates processes that persist after installation, particularly useful 
    for silent deployments where installers don't properly respond to CLI flags.
    
    Features include:
    - Confirmation support (-WhatIf)
    - Detailed uptime logging
    - Error handling and logging
      - Support for terminating multiple instances

  .PARAMETER ProcessName
    The name of the process(es) to terminate (without .exe extension).

  .PARAMETER ProcessID
    The PID for the process to be terminated.

  .PARAMETER LogPath
    Optional path to log file for operation tracking.

  .EXAMPLE
    Kill-Installer -ProcessName "setup" -LogPath "C:\logs\install.log"
    Terminates all instances of setup.exe, logging to the specified file.

  .EXAMPLE
    Kill-Installer -ProcessName "msiexec" -WhatIf
    Shows what would happen if terminating msiexec processes without actually killing them.

  .NOTES
    Use with caution as force-terminating processes may cause installation rollback to fail.
    Consider adding a timeout parameter in future versions.
  #>
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$ProcessName,

    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$ProcessID,

    [string]$LogPath
  )

  begin {
    Write-Log "=== Terminating Stubborn Installer Process ===" -LogPath $LogPath
    Write-Log "Target process: $ProcessName" -LogPath $LogPath
  }

  process {
    try {
      # Get process by name or specific ID if provided
      $processes = if ($ProcessId) {
        Get-Process -Id $ProcessId -ErrorAction SilentlyContinue
      } else {
        Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
      }
      if (-not $processes) {
        Write-Log "No processes found with name/ID '$processes'" -LogPath $LogPath -Level Warning
        return
      }

      foreach ($process in $processes) {
        $uptime = (Get-Date) - $process.StartTime
        Write-Log ("$process.Name Process | ID $($process.Id) | has been running for: {0} days, {1} hours, {2} minutes, {3} seconds" -f 
            $uptime.Days, $uptime.Hours, $uptime.Minutes, $uptime.Seconds) -LogPath $LogPath

        if ($PSCmdlet.ShouldProcess("Process $($process.Id) ($ProcessName)", "Terminate")) {
          $process | Stop-Process -Force -PassThru -ErrorAction Stop
          Write-Log "Successfully terminated $($process.Name) process ID $($process.Id)" -LogPath $LogPath
        }
      }
    }
    catch {
      Write-Log "Termination failed for $ProcessName. Error: $_" -LogPath $LogPath -Level Error
      throw  # Re-throw to maintain original error behavior
    }
  }

  end {
    Write-Log "=== Process Termination Completed ===" -LogPath $LogPath
  }
}

function Invoke-Cleanup {
  <#
  .SYNOPSIS
      Performs post-installation cleanup tasks including group policy update and file transfers.
  
  .DESCRIPTION
      This cmdlet executes standard post-installation tasks:
      - Forces group policy update
      - Copies files from a network location to local machine
  
  .PARAMETER SourceServer
      The network server path containing files to copy
  
  .PARAMETER SourcePath
      The source directory path on the network server
  
  .PARAMETER DestinationPath
      The local destination directory path
  
  .PARAMETER LogPath
      Optional path for log file
  
  .EXAMPLE
      Invoke-PostInstallCleanup -SourceServer "\\server01" -SourcePath "Temp" -DestinationPath "C:\"
  
  .EXAMPLE
      Invoke-PostInstallCleanup -SourceServer $Server -SourcePath "Temp" -DestinationPath "C:\Temp" -LogPath "C:\Logs\cleanup.log"
  #>
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [Parameter(Mandatory = $false)]
    [string]$SourceServer,
    
    [Parameter(Mandatory = $false)]
    [string]$SourcePath,
    
    [Parameter(Mandatory = $false)]
    [string]$DestinationPath,
    
    [string]$LogPath
  )

  begin {
    Write-Log "=== Post-Install Cleanup Started ===" -LogPath $LogPath
    $source = "$SourceServer\$SourcePath"
    Write-Log "Source: $source" -LogPath $LogPath
    Write-Log "Destination: $DestinationPath" -LogPath $LogPath
  }

  process {
    try {
      # Set timezone
      Set-Timezone -Name "Eastern Standard Time"
      # Force group policy update
      if ($PSCmdlet.ShouldProcess("Group Policy", "Update")) {
          gpupdate /force
          Write-Log "Group Policy update applied" -LogPath $LogPath
      }
      # # Copy files
### currently not utilized
      # if ($PSCmdlet.ShouldProcess("Files", "Copy from $source to $DestinationPath")) {
      #     Copy-Item -Path $source -Destination $DestinationPath -Force -Recurse
      #     Write-Log "Copied files from $source to $DestinationPath" -LogPath $LogPath
      # }
    }
    catch {
      Write-Log "Cleanup operation failed: $_" -LogPath $LogPath -Level Error
      throw
    }
  }

  end {
    Write-Log "=== Post-Install Cleanup Completed ===" -LogPath $LogPath
  }
}

function Install-WindowsUpdates {
  <#
  .SYNOPSIS
    Checks for, downloads, and installs all available Windows updates.
  
  .DESCRIPTION
    This function uses the Windows Update Agent API to search for, download, and install all available updates.
    It handles both regular updates and optional updates, with detailed logging and progress reporting.
  
  .EXAMPLE
    Install-WindowsUpdates -AcceptEula -AutoReboot
  
  .PARAMETER AcceptEula
    Automatically accept any EULAs that may be required for updates.
  
  .PARAMETER AutoReboot
    Automatically reboot if required by updates (without prompting).
  
  .PARAMETER IncludeOptional
    Also install optional updates (not recommended for automated deployments).
  
  .NOTES
    Requires administrative privileges. Works on Windows 7 and later.
  #>
  param(
    [switch]$AcceptEula,
    [switch]$AutoReboot,
    [switch]$IncludeOptional
  )

  # Create log file
  $logFile = "WindowsUpdates_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
  $log = @()
  
  Write-Log "=== Windows Update Process Started ==="

  try {
    # Create Windows Update Session
    Write-Log "Initializing Windows Update Agent..."
    $UpdateSession = New-Object -ComObject Microsoft.Update.Session
    $UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
    $UpdateDownloader = $UpdateSession.CreateUpdateDownloader()
    $UpdateInstaller = $UpdateSession.CreateUpdateInstaller()
    
    # Configure settings
    $UpdateInstaller.AllowSourcePrompts = $false
    $UpdateInstaller.ForceQuiet = $true
    if ($AcceptEula) { $UpdateInstaller.AcceptEula = $true }

    # Search for updates
    Write-Log "Searching for available updates..."
    $SearchResult = $UpdateSearcher.Search("IsInstalled=0 and Type='Software'")
    
    if ($SearchResult.Updates.Count -eq 0) {
        Write-Log "No updates found. System is up to date."
        return
    }

    # Filter updates
    $UpdatesToInstall = New-Object -ComObject Microsoft.Update.UpdateColl
    $totalSize = 0
    $updateCount = 0

    foreach ($Update in $SearchResult.Updates) {
      # Skip if not needed
      if (-not $IncludeOptional -and $Update.AutoSelectOnWebSites -eq $false) {
          Write-Log "Skipping optional update: $($Update.Title)"
          continue
      }

      $UpdatesToInstall.Add($Update) | Out-Null
      $totalSize += $Update.MaxDownloadSize
      $updateCount++
      Write-Log "Found update: $($Update.Title) (Size: $([math]::Round($Update.MaxDownloadSize/1MB,2)) MB)"
    }

    if ($updateCount -eq 0) {
      Write-Log "No applicable updates found after filtering."
      return
    }

    Write-Log "Preparing to install $updateCount updates (Total size: $([math]::Round($totalSize/1MB,2)) MB)"

    # Download updates
    Write-Log "Downloading updates..."
    $UpdateDownloader.Updates = $UpdatesToInstall
    $DownloadResult = $UpdateDownloader.Download()

    if ($DownloadResult.ResultCode -ne 2) {
      Write-Log "WARNING: Some updates failed to download. HResult: $($DownloadResult.HResult)"
    }

    # Install updates
    Write-Log "Installing updates..."
    $UpdateInstaller.Updates = $UpdatesToInstall
    $InstallResult = $UpdateInstaller.Install()


    # Report results
    Write-Log "=== Installation Results ==="
    Write-Log "Reboot required: $($InstallResult.RebootRequired)"
    Write-Log "Result code: $($InstallResult.ResultCode)"
    
    if ($InstallResult.RebootRequired) {
      if ($AutoReboot) {
        Write-Log "System will reboot in 1 minute..."
        Start-Process "shutdown.exe" -ArgumentList "/r /t 60 /c ""Rebooting to complete Windows updates installation"""
      } else {
        Write-Log "WARNING: Updates require a reboot to complete installation."
      }
    }

    # Detailed results
    Write-Log "`n=== Update Details ==="
    for ($i = 0; $i -lt $UpdatesToInstall.Count; $i++) {
      $update = $UpdatesToInstall.Item($i)
      $result = $InstallResult.GetUpdateResult($i)
      $status = switch ($result.ResultCode) {
          0 { "Not Started" }
          1 { "In Progress" }
          2 { "Success" }
          3 { "Success With Errors" }
          4 { "Failed" }
          5 { "Aborted" }
          default { "Unknown" }
      }
      Write-Log "$($update.Title.PadRight(60)) - $status"
    }
    Write-Log "Windows update process completed."
  }
  catch {
    Write-Log "ERROR: $_"
    Write-Log "Exception details: $($_.Exception.Message)"
    throw
  }
  finally {
    # Save log to file
    $log | Out-File -FilePath $logFile -Force
    Write-Log "Log file saved to: $logFile"
  }
}

function Invoke-DellCommandUpdate {
  <#
  .SYNOPSIS
    Executes Dell Command Update (DCU-CLI.exe) with comprehensive logging.
  
  .DESCRIPTION
    Runs Dell's update utility to scan, download, and install firmware/driver updates.
    Provides detailed logging of the update process and handles reboot requirements.
  
  .PARAMETER Operation
    The DCU operation to perform: Scan, Download, Install, or All (default: All)
  
  .PARAMETER Reboot
    Allow system reboot if required by updates (default: false)
  
  .PARAMETER LogPath
    Optional path for log file
  
  .EXAMPLE
    Invoke-DellCommandUpdate -Operation All -Reboot:$true
  
  .EXAMPLE
    Invoke-DellCommandUpdate -Operation Scan -LogPath C:\Logs\DellUpdates.log
  
  .NOTES
    Requires Dell Command Update to be installed.
    Administrative privileges are required.
  #>
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [ValidateSet('Scan', 'Download', 'Install', 'All')]
    [string]$Operation = 'All',

    [switch]$Reboot,

    [string]$LogPath
  )

  begin {
    $dcuPath = "${env:ProgramFiles}\Dell\CommandUpdate\dcu-cli.exe"
    $validExitCodes = @(0, 2, 3, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255)
    Write-Log "=== Dell Command Update Process Started ===" -LogPath $LogPath
    Write-Log "Operation: $Operation" -LogPath $LogPath
    Write-Log "Reboot allowed: $Reboot" -LogPath $LogPath
  }

  process {
    try {
      $arguments = switch ($Operation) {
          'Scan'    { '/scan' }
          'Download'{ '/download' }
          'Install' { '/applyUpdates' }
          'All'     { '/applyUpdates -autoSuspendBitLocker=enable' }
      }

      if ($Reboot) {
          $arguments += ' -reboot=enable'
      } else {
          $arguments += ' -reboot=disable'
      }

      Write-Log "Executing: $dcuPath $arguments" -LogPath $LogPath
      $startTime = Get-Date

      $process = Start-Process -FilePath $dcuPath -ArgumentList $arguments -NoNewWindow -PassThru -Wait -ErrorAction Stop
      $exitCode = $process.ExitCode
      $duration = (Get-Date) - $startTime

      if ($validExitCodes -contains $exitCode) {
        $message = if ($exitCodeMap.ContainsKey($exitCode)) {
            $exitCodeMap[$exitCode]
        } else {
            "Completed with unrecognized success code"
        }
        Write-Log "SUCCESS: $message (Exit Code: $exitCode, Duration: $($duration.TotalSeconds) seconds" -LogPath $LogPath
      } else {
        $message = if ($exitCodeMap.ContainsKey($exitCode)) {
            $exitCodeMap[$exitCode]
        } else {
            "Failed with unrecognized error code"
        }
        Write-Log "ERROR: $message (Exit Code: $exitCode, Duration: $($duration.TotalSeconds) seconds" -LogPath $LogPath -Level Error
      }
    }
    catch {
      Write-Log "FATAL: Failed to execute Dell Command Update: $($_.Exception.Message)" -LogPath $LogPath -Level Error
      throw
    }
  }
  end {
    Write-Log "=== Dell Command Update Process Completed ===" -LogPath $LogPath
  }
}

function Enable-BitLockerAndBackup {
  <#
  .SYNOPSIS
    Enables BitLocker encryption and backs up the recovery key to Microsoft Entra ID.

  .DESCRIPTION
    This cmdlet enables BitLocker encryption on the specified drive using TPM protection,
    and automatically backs up the recovery key to the device's registered Entra ID tenant.

  .PARAMETER DriveLetter
    The drive letter to encrypt (default is C:).

  .PARAMETER EncryptionMethod
    The encryption method to use (Aes128, Aes256, XtsAes128, XtsAes256).

  .PARAMETER SkipHardwareTest
    Skip the hardware compatibility test (not recommended).

  .PARAMETER UsedSpaceOnly
    Encrypt only used disk space (faster for drives with lots of free space).

  .EXAMPLE
    Enable-BitLockerWithEntraBackup
    Encrypts C: drive with default settings and backs up key to Entra ID

  .EXAMPLE
    Enable-BitLockerWithEntraBackup -DriveLetter D: -EncryptionMethod XtsAes256
    Encrypts D: drive with strongest encryption method

  .NOTES
    Requires:
    - Windows 10/11 Pro/Enterprise or Windows Server 2016+
    - BitLocker feature enabled
    - TPM chip (1.2 or 2.0 recommended)
    - Device registered with Microsoft Entra ID
    - Administrative privileges
  #>

  [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
  param (
    [Parameter()]
    [ValidatePattern('^[A-Z]$')]
    [string]$DriveLetter = 'C',

    [Parameter()]
    [ValidateSet('Aes128', 'Aes256', 'XtsAes128', 'XtsAes256')]
    [string]$EncryptionMethod = 'XtsAes256',

    [Parameter()]
    [switch]$SkipHardwareTest,

    [Parameter()]
    [switch]$UsedSpaceOnly,

    [Parameter()]
    [string]$LogPath
  )

  begin {
    # Check prerequisites
    if (-not (Get-Command -Name 'Manage-BDE' -ErrorAction SilentlyContinue)) {
      Write-Log "BitLocker Drive Encryption tools are not available. This feature might need to be installed." -Level Error -LogPath $LogPath
      throw 
    }

    if (-not (Get-Tpm -ErrorAction SilentlyContinue)) {
      Write-Log "Trusted Platform Module (TPM) is not available or not enabled in BIOS." -Level Error -LogPath $LogPath
      throw
    }

    $drivePath = "$($DriveLetter):"
    if (-not (Test-Path -Path $drivePath)) {
      Write-Log "Drive $drivePath does not exist" -Level Error -LogPath $LogPath
      throw
    }
  }

  process {
    if ($PSCmdlet.ShouldProcess("Drive $drivePath", "Enable BitLocker encryption with Entra ID key backup")) {
      try {
        Write-Log "Starting BitLocker encryption process on $drivePath" -Level Info -LogPath $LogPath

        # Set encryption method
        $encryptionArg = switch ($EncryptionMethod) {
          'Aes128'    { 'AES128' }
          'Aes256'    { 'AES256' }
          'XtsAes128' { 'AES128' }
          'XtsAes256' { 'AES256' }
        }

        Write-Log "Enabling BitLocker with TPM protection" -Level Info -LogPath $LogPath
        Enable-BitLocker -MountPoint $drivePath -EncryptionMethod $encryptionArg -TpmProtector -SkipHardwareTest -UsedSpaceOnly

        # Wait for initial encryption to start
        Write-Log "Waiting for encryption to initialize..." -Level Info -LogPath $LogPath
        do {
          Start-Sleep -Seconds 5
          $status = Get-BitLockerVolume -MountPoint $drivePath
        } while ($status.VolumeStatus -eq 'FullyDecrypted')

        # Backup recovery key to Entra ID
        Write-Log "Backing up recovery key to Microsoft Entra ID" -Level Info -LogPath $LogPath
        $keyProtector = Get-BitLockerVolume -MountPoint $drivePath | 
            Select-Object -ExpandProperty KeyProtector | 
            Where-Object { $_.KeyProtectorType -eq 'RecoveryPassword' }

        if ($keyProtector) {
          BackupToAAD-BitLockerKeyProtector -MountPoint $drivePath -KeyProtectorId $keyProtector.KeyProtectorId
          Write-Log "Successfully backed up recovery key to Entra ID" -Level Info -LogPath $LogPath
        }
        else {
          Write-Log "No recovery password protector found - key may not have been backed up" -Level Warning -LogPath $LogPath
        }

        # Show encryption progress
        Write-Host "Encryption in progress. Current status:"
        Get-BitLockerVolume -MountPoint $drivePath | 
            Select-Object MountPoint, VolumeStatus, EncryptionPercentage | 
            Format-Table -AutoSize

        Write-Log "BitLocker encryption started successfully. The recovery key has been saved to Microsoft Entra ID." -Level Info -LogPath $LogPath
      }
      catch {
          Write-Log "Failed to enable BitLocker: $_"
          throw
      }
    }

    end {
      if ($PSBoundParameters.ContainsKey('WhatIf')) {
        Write-Log "WhatIf: BitLocker would have been enabled on $drivePath with recovery key backed up to Entra ID" -Level Info -LogPath $LogPath
      }
    }
  }
}


function Get-FileFromList {
  <#
  .SYNOPSIS
    For dealing with self-deleting installers, download to a local folder.

  .DESCRIPTION
    This works in conjunction with cmdlet Install-EXE and Install-MSI to handle issues that can arise from installers that self-delete.

  .PARAMETER SrcPath
    Path where the file exists

  .PARAMETER DstPath
    Local path to copy file to

  .PARAMETER FileList
    List file

  .EXAMPLE
    Download-Installers
  #>

  [CmdletBinding(SupportsShouldProcess = $true)]
    param (
      [Parameter()]
      [string]$SrcPath,

      [Parameter()]
      [string]$DstPath,

      [Parameter()]
      [string]$FileList
    )

  begin {
    if (-not $FileList) {
      $FileList = ".\downloadFiles.txt"
    }
    if (-not $DstPath) {
      $DstPath = $Env:HOMEPATH
    }
    if ($SrcPath) {
      $SrcPath = Get-Content -Path $FileList | ForEach-Object { $_.Trim() }
    } else {
      $SrcPath = @()
    }
  }

  process {
    foreach ($src in $SrcPath){
      if (Test-Path -Path $src -PathType Leaf){
        $file = Split-Path $src -leaf
        try {
          Write-Log "Copying file $file from $src to $DestPath\$file" -Level Info -LogPath $LogPath
          if ($ShouldProcess){
            Copy-Item -Path $src -Destination "$DstPath\$file"
          }
        }
        catch {
          Write-Log "Unable to copy file from $src to $DstPath"
        }
      }
    }
  }

  end {

  }

}

function Mount-NetworkShares {
  <#
  .SYNOPSIS
    Mount network shares

  .DESCRIPTION
    Reads a list of paths and mounts them as network shares to the specified drive letter
  
  .PARAMETER MntPath
    Network share path if mounting a single item

  .PARAMETER MntLetter
    Letter to use when mounting single item

  .PARAMETER SharesList
    List of shares and drive letters for mounting more than one item
  #>

  [CmdletBinding(SupportsShouldProcess = $true)]
    param (
      [Parameter(ValueFromPipeline = $true, Position = 0)]
      [array]$SharesList,

      [string]$MntPath,

      [string]$MntLetter,

      [string]$Group
    )

  begin {
    if (-not $SharesList){
      if ((-not $MntPath) -or (-not $MntLetter)){
        $MntLetter  = Read-Host "What is the Drive letter?"
        $MntPath    = Read-Host "What is the full share path?"
      }
      $SharesList   = @(
        [PSCustomObject]@{
          Letter    = $MntLetter
          Path      = $MntPath
          Group     = ""
        }
      )
    }
  }

  process {
    foreach ($item in $SharesList){
      if (($item.Group -eq $Group) -or ($item.Group -eq "all")) {
        try {
          $exists = Get-PSDrive -Name $item.Letter -ErrorAction Stop
          Write-Log "Drive letter already exists at $($exists.Name), skipping"
        }catch{
            Write-Log "Adding $($item.Path) to drive letter $($item.Letter)"
            New-PSDrive -Name $item.Letter -Root $item.Path -Persist -PSProvider "Filesystem" -Scope Global -ErrorAction Stop
        }
      }
    }
  }

  end {

  }
}

function Add-QuickAccess {
  <#
  .SYNOPSIS
    Add QuickAccess items to a profile

  .DESCRIPTION
    Add QuickAccess items to File Explorer from a list

  .PARAMETER List
    Array of custom objects containing link information 

  .PARAMETER Pin
    Path when there is only one item to pin

  .PARAMETER Action
    Pin or unpin the item
  #>

  [CmdletBinding()]
  param(
    [Parameter(ValueFromPipeline = $true, Position = 0)]
    [array]$List,
    
    [string]$Pin,

    [string]$Action,

    [string]$Group
  )

  begin {
    if ((-not $Action) -or ($Action -eq "pin")) {
      $Action = "PinToHome"
    }elseif ($Action -eq "unpin") {
      $Action = "UnpinFromHome"
    }
    if (-not $List){
      if (-not $Pin){
        $Pin = Read-Host "What is the path that you want to add to QuickAccess? "
      }
      $List = @(
        [PSCustomObject]@{
          $path   = $Pin
        }
      )
    }
    $objShell     = New-Object -ComObject Shell.Application
    $ns           = "shell:::{679f85cb-0220-4080-b29b-5540cc05aab6}"
    $CurrentPins  = ($objShell.Namespace($ns).Items() | Where-Object { $_.IsFolder -eq $true }).Name
  }


  process {
    foreach ($item in $List){
      $path1 = Split-Path -Path $item.path -Leaf
      if ($Action -eq "PinToHome") {
        if ($path1 -in $CurrentPins) {
          Write-Log "$($item.path) is already Pinned to QuickAccess, skipping"
        }
        elseif ($path1 -notin $CurrentPins) {
          $objShell.NameSpace( $item.path ).Self.InvokeVerb($Action)
          Write-Log "$($item.path) pinned to QuickAccess"
        }
        else {
          Write-Log "Error in checking Current pins, No action taken"
        }
      }
      elseif ($Action -eq "UnpinFromHome") {
        if ($path1 -in $CurrentPins) {
          $objShell.NameSpace( $item.path ).Self.InvokeVerb($Action)
          Write-Log "$($item.path) unpinned from QuickAccess"
        }
        elseif ($path1 -notin $CurrentPins) {
          Write-Log "$($item.path) is not Pinned to QuickAccess, skipping"
        }
        else {
          Write-Log "Error in checking Current pins, No action taken"
        }
      }
    }
  }

  end{

  }

}

function Install-Printers {
  <#
  .SYNOPSIS

  .DESCRIPTION

  .PARAMETER Queue
    Print server's path to the print queue

  .PARAMETER Group
    Group that the user will be part of
  #>

  [CmdletBinding()]
  param(
    [Parameter(ValueFromPipeline = $true, Position = 0)]
    [array]$List,
    
    [string]$Pin,

    [string]$Action,

    [string]$Group
  )

}