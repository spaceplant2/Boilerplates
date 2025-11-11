###   Use SysInternals tools to examine a windows system for possible malicious activity

function Pull-SystemInformation {
  <#
  .SYNOPSIS
    The beginnings of a forensic investigation
  
  .DESCRIPTION
    Quick and dirty information gathering for an initial forensic exam of a potentially compromised
    Windows system. Uses system and SysInternals utilities

  .PARAMETER

  .EXAMPLE
  #>
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [Parameter()]
    [string]$logOut,
    
    [Parameter()]
    [string]$consoleOut
  )

  begin {
    $date = $(Get-Date -UFormat "%Y-%M-%d")
    $logPath = "$(pwd)\$($env:COMPUTERNAME)"
    $logFile = $logPath += "-$date"
    Write-Host "saving log file at $logFile"
  }

  process {
    Add-Content -Path "$logfile-users.log" -Encoding utf8 -Value "****   Logged on Users   ****`n"
    Add-Content -Path "$logfile-users.log" -Encoding utf8 -Value $(SysinternalsSuite/psloggedon /accepteula)
    Add-Content -Path "$logfile-users.log" -Encoding utf8 -Value $(SysinternalsSuite/logonsessions /accepteula)
    Add-Content -Path "$logfile-users.log" -Encoding utf8 -Value "`n"

    Add-Content -Path "$logfile-Info.log" -Encoding utf8 -Value "**** PSInfo Output ****`n"
    Add-Content -Path "$logfile-Info.log" -Encoding utf8 -Value $(SysinternalsSuite/psinfo /accepteula -s -d)
    Add-Content -Path "$logfile-Info.log" -Encoding utf8 -Value "`n"

    # Add-Content -Path "$logfile-DLLs.log" -Encoding utf8 -Value "**** ListDLLs Output ****`n"
    # Add-Content -Path "$logfile-DLLs.log" -Encoding utf8 -Value $(SysinternalsSuite/listdlls /accepteula)
    # Add-Content -Path "$logfile-DLLs.log" -Encoding utf8 -Value "`n"

    Add-Content -Path "$logfile-PSlist.log" -Encoding utf8 -Value "**** PSList Output ****`n"
    Add-Content -Path "$logfile-PSlist.log" -Encoding utf8 -Value $(SysinternalsSuite/pslist /accepteula)
    Add-Content -Path "$logfile-PSlist.log" -Encoding utf8 -Value "`n"

    Add-Content -Path "$logfile-Moves.log" -Encoding utf8 -Value "****   PendMoves output   ****`n"
    Add-Content -Path "$logfile-Moves.log" -Encoding utf8 -Value $(SysinternalsSuite/pendmoves  /accepteula)
    Add-Content -Path "$logfile-Moves.log" -Encoding utf8 -Value "`n"

    Write-Host "Building autorun file $logpath-autoruns.csv"
    SysinternalsSuite/autorunsc  /accepteula -a * -c -o "$logpath-autoruns.csv"
    
  }

  end {

  }
}


function Create-FileHash {
  <#
  .SYNOPSIS
    Has a file for checks against online services
  #>
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
    [string]$InFile,

    [Parameter()]
    [string]$OutFile
  )

  begin {
    if (! $InFile) {
      $InFile = Get-FileName
    }
    $fileName = Split-Path -Path $InFile -Leaf
    if (! $OutFile){
      $OutFile = "$(pwd)\$fileName-hash.txt"
    }
  }

  process {
    $md5Sum = Get-FileHash -Path $inFile -Algorithm MD5
    $sha1Sum = Get-FileHash -Path $inFile -Algorithm SHA1
    $sha256Sum = Get-FileHash -Path $inFile -Algorithm SHA256

    Add-Content -Path $OutFile -Encoding utf8 -Value "`n****   File hashes for upload to (i.e) VirusTotal"
    Add-Content -Path $OutFile -Encoding utf8 -Value "`n`n****   MD5 sum       ****"
    Add-Content -Path $OutFile -Encoding utf8 -Value $md5Sum.Hash
    Add-Content -Path $OutFile -Encoding utf8 -Value "`n`n****   SHA1 sum      ****"
    Add-Content -Path $OutFile -Encoding utf8 -Value $sha1Sum.Hash
    Add-Content -Path $OutFile -Encoding utf8 -Value "`n`n****   SHA256 sum    ****"
    Add-Content -Path $OutFile -Encoding utf8 -Value $sha256Sum.Hash

  }

  end {

  }
}

function Create-FileArchive {
  <#
  .SYNOPSIS
    create an archive of a file for analysis
  #>
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
    [string]$InFile,

    [Parameter(Mandatory=$false)]
    [string]$OutFile
  )

  begin{
    if (! $InFile) {
      $InFile = Get-FileName -InitialDirectory "C:\"
    }
    if (! $OutFile) {
      $FileNoPath = Split-Path -Path $InFile -Leaf
      $OutFile = "$(pwd)\$FileNoPath.zip"
    }
  }

  process {
    Compress-Archive -Path $InFile -DestinationPath $OutFile
  }

  end {

  }
}

function Get-FileName {
  <#
    .SYNOPSIS
      GUI file picker
  #>
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [Parameter(Mandatory=$false)]
    [string]$InitialDirectory
  )

  begin {
    if (! $InitialDirectory) {
      $InitialDirectory = $(pwd)
    }
    Add-Type -AssemblyName System.Windows.Forms
  }

  process {
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $InitialDirectory
    $OpenFileDialog.filter = "Documents (*.*)|*.*"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.FileName
  }

  end {

  }
}

###   launcher
Pull-SystemInformation

while (($examineFile -ne "y") -and ($examineFile -ne "n")) {
  $examineFile = Read-Host "Do you have a file that needs to be examined?"
}
if ($examineFile -eq "y") {
  $examineFilePath = Get-FileName -InitialDirectory "C:\"
  Create-FileHash -InFile $examineFilePath
  Create-FileArchive -InFile $examineFilePath
}

