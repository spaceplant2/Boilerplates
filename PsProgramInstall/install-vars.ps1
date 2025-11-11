###   List of exit codes for installers https://docs.netecm.ch/launcher/troubleshooting/msi-exit-codes.html

$msi_installers = @(
  [PSCustomObject]@{
    Name      = "Automox"
    Action    = "/I"
    Path      = "$server\Automox\Automox.msi"
    Args      = "/qb ACCESSKEY=9383bb0e-c93a-4891-b037-157a715faa7b"
  },
  [PSCustomObject]@{
    Name      = "AirTame"
    Action    = "/I"
    Path      = "$server\Airtame\Airtame-4.10.0-setup.msi"
    Args      = "/qb"
  },
  [PSCustomObject]@{
    Name      = "Cortex"
    Action    = "/I"
    Path      = "$server\PaloAlto\Cortex_87_x64.msi"
    Args      = "/qb"
  },
  [PSCustomObject]@{
    Name      = "Cyberark"
    Action    = "/I"
    Path      = "$server\Cyberark\VFAgentSetupX64_25.2.msi"
    Args      = "/qb INSTALLATIONKEY=bkYoKmMtX2w5Ok8lIkpLZ0E3R183UUhMIm9rO3JuZzE= CONFIGURATION=$server\Cyberark\CyberArk25.2.0.2476\CyberArkEPMAgentSetupWindows.config"
  },
  [PSCustomObject]@{
    Name      = "Malwarebytes"
    Action    = "/I"
    Path      = "$server\Malwarebytes\MBEndpointAgent.x64.msi"
    Args      = "/qb"
  },
  [PSCustomObject]@{
    Name      = "Mimecast"
    Action    = "/I"
    Path      = "$server\Mimecast\Mimecast_for_outlook.msi"
    Args      = "/qb"
  },
  [PSCustomObject]@{
    Name      = "GlobalProtect"
    Action    = "/I"
    Path      = "$server\PaloAlto\GlobalProtect64.msi"
    Args      = "PORTAL=connect.muellercompany.com /qb"
  },
  [PSCustomObject]@{
    Name      = "Zoom Plugin"
    Action    = "/I"
    Path      = "$server\Zoom\ZoomOutlookPluginSetup.msi"
    Args      = "/qb"
  }
)

# Define our installers
$exe_installers = @(
  [PSCustomObject]@{
    Name      = "Office"
    Path      = "$server\Microsoft\OfficeSetup.exe"
    Args      = "Setup"
    ValidExitCodes = @(0, 3010)
  },
  [PSCustomObject]@{
    Name      = "Acrobat"
    Path      = "~\Acrobat_Reader_en_install.exe"
    Args      = "/quiet /norestart"
    ValidExitCodes = @(0, 3010)
  },
  # [PSCustomObject]@{
  #   Name       = "Bomgar Client"
  #   Path       = "~\bomgar-scc-w0eec30d1yhe6i17hxh8wwgd8wh8zz7iezywd7zc40hc90.exe"
  #   Args       = "/quiet"
  #   ValidExitCodes = @(0, 3010)
  # },
  [PSCustomObject]@{
    Name      = "Dell Update"
    Path      = "$server\Dell\Dell-Command.exe"
    Args      = "/s"
    ValidExitCodes = @(0, 2, 3010)
  },
  [PSCustomObject]@{
    Name      = "Chrome"
    Path      = "$server\Google\ChromeSetup.exe"
    Args      = "/install /silent"
    ValidExitCodes = @(0, 3010)
  },
  [PSCustomObject]@{
    Name      = "Firefox"
    Path      = "$server\Mozilla\FirefoxSetup.exe"
    Args      = "/s"
    ValidExitCodes = @(0, 3010)
  },
  [PSCustomObject]@{
    Name      = "Logitech Unifying"
    Path      = "$server\logi\unifying252.exe"
    Args      = "/S"
    ValidExitCodes = @(0, 3010)
  },
  [PSCustomObject]@{
    Name      = "Logitech Options+"
    Path      = "$server\logi\logioptionsplus_installer.exe"
    Args      = "/quiet"
    ValidExitCodes = @(0, 3010)
  },
  [PSCustomObject]@{
    Name      = "PhishAlert"
    Path      = "$server\PhishAlert\PhishAlertButtonSetup.exe"
    Args      = '/q /ComponentArgs "MainInstaller":"LICENSEKEY=""4EC90AC040A9F1514C4B12E6A277D147"""'
    ValidExitCodes = @(0, 3010)
  },
  [PSCustomObject]@{
    Name      = "VCredist 2019"
    Path      = "$server\Microsoft\VC_redist.x64.exe"
    Args      = "/install /passive /quiet /norestart"
    ValidExitCodes = @(0, 3010)
  },
  [PSCustomObject]@{
    Name      = "Zoom"
    Path      = "$server\Zoom\ZoomInstallerFull.exe"
    Args      = "/qb /norestart"
    ValidExitCodes = @(0, 3010)
  }
)

$freecad_exe_installers = @(
  [PSCustomObject]@{
    Name      = "TrueView"
    Path      = "$server\DWGTrueView\Setup.exe"
    Args      = "--silent"
    ValidExitCodes = @(0, 3010)
  },
  [PSCustomObject]@{
    Name      = "CreoView"
    Path      = "$server\CreoView\CreoView_Express-12.0.0-x86e_win64.exe"
    Args      = "/v /qb"
    ValidExitCodes = @(0, 3010)
  },
  [PSCustomObject]@{
    Name      = "VC-Redistx64"
    Path      = "$server\Microsoft\VC_redist.x64.exe"
    Args      = "/install /passive /quiet /norestart"
    ValidExitCodes = @(0, 3010)
  }
)

$network_shares = @(
  [PSCustomObject]@{
    Letter    = "Y"
    Path      = "\\kim-fs1\Taicang"
    Group     = "Singer"
  },
  [PSCustomObject]@{
    Letter    = "Z"
    Path      = "\\Kim-fs1\Surrey"
    Group     = "Singer"
  },
    [PSCustomObject]@{
    Letter    = "W"
    Path      = "\\kim-fs1\Public"
    Group     = "all"
  },
  [PSCustomObject]@{
    Letter    = "S"
    Path      = "\\kim-fs1\Departmentals"
    Group     = "all"
  }

  # [PSCustomObject]@{
  #   Letter    = ""
  #   Path      = ""
  #   Group     = ""
  # }
)

$pin_items = @(
  [PSCustomObject]@{
    Path      = "\\kim-fs1\Taicang\Drawings & Parts Lists"
    Group     = "Singer"
  },
  [PSCustomObject]@{
    Path      = "\\kim-fs1\Surrey\Rebuild Kit Part Lists"
    Group     = "Singer"
  },
  [PSCustomObject]@{
    Path      = "\\kim-fs1\Surrey\Photos\Singer Piping Images"
    Group     = "Singer"
  },
  [PSCustomObject]@{
    Path      = "\\cle-fs1\departmentals\CLE-Singer\SINGER 651 IOM MANUALS"
    Group     = "Singer"
  },
  [PSCustomObject]@{
    Path      = "\\kim-fs1\Surrey\Customer Service and Technical Support\Submittal Information"
    Group     = "Singer"
  }
)

$exitCodeMap = @{
  # Common Success Codes
  0 = @{ Message = "Success"; Severity = "Info" }
  3010 = @{ Message = "Success, reboot required"; Severity = "Warning" }

  # MSI Error Codes
  1601 = @{ Message = "Windows Installer service not accessible"; Severity = "Error" }
  1602 = @{ Message = "User cancelled installation"; Severity = "Warning" }
  1603 = @{ Message = "Fatal error during installation"; Severity = "Error" }
  1618 = @{ Message = "Another installation already in progress"; Severity = "Error" }
  1619 = @{ Message = "Could not open installer package"; Severity = "Error"}
  1620 = @{ Message = "Invalid command line argument"; Severity = "Error" }
  1638 = @{ Message = "Incompatible version already installed"; Severity = "Error" }

  # InstallShield Error Codes
  1 = @{ Message = "General error (out of memory/invalid handle)"; Severity = "Error" }
  2 = @{ Message = "Invalid mode (server install on workstation OS)"; Severity = "Error" }
  3 = @{ Message = "Data not found in media"; Severity = "Error" }
  4 = @{ Message = "Unable to load SQL DLL"; Severity = "Error" }
  5 = @{ Message = "Unable to connect to SQL DB"; Severity = "Error" }
  6 = @{ Message = "Failure to create service"; Severity = "Error" }
  7 = @{ Message = "Failure to start service"; Severity = "Error" }
  8 = @{ Message = "Unable to stop service"; Severity = "Error" }
  9 = @{ Message = "Unable to delete service"; Severity = "Error" }
  10 = @{ Message = "DLL/EXE load failure"; Severity = "Error" }
  11 = @{ Message = "Registry error"; Severity = "Error" }
  12 = @{ Message = "Invalid command line argument"; Severity = "Error" }
  13 = @{ Message = "Invalid XML file"; Severity = "Error" }
  14 = @{ Message = "Invalid INI file"; Severity = "Error" }
  15 = @{ Message = "Unable to remove file"; Severity = "Error" }
  16 = @{ Message = "Unable to create folder"; Severity = "Error" }
  17 = @{ Message = "Unable to remove folder"; Severity = "Error" }
  18 = @{ Message = "Unable to register DLL/OCX"; Severity = "Error" }
  19 = @{ Message = "Unable to unregister DLL/OCX"; Severity = "Error" }
  20 = @{ Message = "Unable to create shortcut"; Severity = "Error" }
  21 = @{ Message = "Unable to remove shortcut"; Severity = "Error" }
  22 = @{ Message = "Unable to install driver"; Severity = "Error" }
  23 = @{ Message = "Unable to uninstall driver"; Severity = "Error" }
  24 = @{ Message = "Unable to install INF"; Severity = "Error" }
  25 = @{ Message = "Unable to uninstall INF"; Severity = "Error" }
  26 = @{ Message = "Unable to stop process"; Severity = "Error" }
  27 = @{ Message = "Unable to kill process"; Severity = "Error" }
  28 = @{ Message = "Unable to set security"; Severity = "Error" }
  29 = @{ Message = "Unable to modify file"; Severity = "Error" }
  30 = @{ Message = "Unable to modify registry"; Severity = "Error" }
  31 = @{ Message = "Unable to modify service"; Severity = "Error" }
  32 = @{ Message = "Unable to modify shortcut"; Severity = "Error" }
  33 = @{ Message = "Unable to modify folder"; Severity = "Error" }
  34 = @{ Message = "Unable to modify driver"; Severity = "Error" }
  35 = @{ Message = "Unable to modify INF"; Severity = "Error" }
  36 = @{ Message = "Unable to modify process"; Severity = "Error" }
  37 = @{ Message = "Unable to modify security"; Severity = "Error" }
  38 = @{ Message = "Unable to modify XML"; Severity = "Error" }
  39 = @{ Message = "Unable to modify INI"; Severity = "Error" }
  40 = @{ Message = "Unable to modify environment"; Severity = "Error" }
  41 = @{ Message = "Unable to modify user"; Severity = "Error" }
  42 = @{ Message = "Unable to modify group"; Severity = "Error" }
  43 = @{ Message = "Unable to modify computer"; Severity = "Error" }
  44 = @{ Message = "Unable to modify domain"; Severity = "Error" }
  45 = @{ Message = "Unable to modify network"; Severity = "Error" }
  46 = @{ Message = "Unable to modify printer"; Severity = "Error" }
  47 = @{ Message = "Unable to modify share"; Severity = "Error" }
  48 = @{ Message = "Unable to modify time"; Severity = "Error" }
  49 = @{ Message = "Unable to modify timezone"; Severity = "Error" }
  50 = @{ Message = "Unable to modify language"; Severity = "Error" }
  51 = @{ Message = "Unable to modify currency"; Severity = "Error" }
  52 = @{ Message = "Unable to modify measurement"; Severity = "Error" }
  53 = @{ Message = "Unable to modify keyboard"; Severity = "Error" }
  54 = @{ Message = "Unable to modify mouse"; Severity = "Error" }
  55 = @{ Message = "Unable to modify sound"; Severity = "Error" }
  56 = @{ Message = "Unable to modify display"; Severity = "Error" }
  57 = @{ Message = "Unable to modify power"; Severity = "Error" }
  58 = @{ Message = "Unable to modify battery"; Severity = "Error" }
  59 = @{ Message = "Unable to modify processor"; Severity = "Error" }
  60 = @{ Message = "Unable to modify memory"; Severity = "Error" }
  61 = @{ Message = "Unable to modify disk"; Severity = "Error" }
  62 = @{ Message = "Unable to modify network adapter"; Severity = "Error" }
  63 = @{ Message = "Unable to modify modem"; Severity = "Error" }
  64 = @{ Message = "Unable to modify serial port"; Severity = "Error" }
  65 = @{ Message = "Unable to modify parallel port"; Severity = "Error" }
  66 = @{ Message = "Unable to modify USB"; Severity = "Error" }
  67 = @{ Message = "Unable to modify FireWire"; Severity = "Error" }
  68 = @{ Message = "Unable to modify SCSI"; Severity = "Error" }
  69 = @{ Message = "Unable to modify IDE"; Severity = "Error" }
  70 = @{ Message = "Unable to modify RAID"; Severity = "Error" }
  71 = @{ Message = "Unable to modify SAN"; Severity = "Error" }
  72 = @{ Message = "Unable to modify NAS"; Severity = "Error" }
  73 = @{ Message = "Unable to modify DAS"; Severity = "Error" }
  74 = @{ Message = "Unable to modify tape"; Severity = "Error" }
  75 = @{ Message = "Unable to modify optical"; Severity = "Error" }
  76 = @{ Message = "Unable to modify removable"; Severity = "Error" }
  77 = @{ Message = "Unable to modify fixed"; Severity = "Error" }
  78 = @{ Message = "Unable to modify virtual"; Severity = "Error" }
  79 = @{ Message = "Unable to modify cloud"; Severity = "Error" }
  80 = @{ Message = "Unable to modify cluster"; Severity = "Error" }
  81 = @{ Message = "Unable to modify grid"; Severity = "Error" }
  82 = @{ Message = "Unable to modify fabric"; Severity = "Error" }
  83 = @{ Message = "Unable to modify utility"; Severity = "Error" }
  84 = @{ Message = "Unable to modify service"; Severity = "Error" }
  85 = @{ Message = "Unable to modify application"; Severity = "Error" }
  86 = @{ Message = "Unable to modify database"; Severity = "Error" }
  87 = @{ Message = "Unable to modify web"; Severity = "Error" }
  88 = @{ Message = "Unable to modify mail"; Severity = "Error" }
  89 = @{ Message = "Unable to modify security"; Severity = "Error" }
  90 = @{ Message = "Unable to modify backup"; Severity = "Error" }
  91 = @{ Message = "Unable to modify restore"; Severity = "Error" }
  92 = @{ Message = "Unable to modify replication"; Severity = "Error" }
  93 = @{ Message = "Unable to modify synchronization"; Severity = "Error" }
  94 = @{ Message = "Unable to modify migration"; Severity = "Error" }
  95 = @{ Message = "Unable to modify upgrade"; Severity = "Error" }
  96 = @{ Message = "Unable to modify downgrade"; Severity = "Error" }
  97 = @{ Message = "Unable to modify patch"; Severity = "Error" }
  98 = @{ Message = "Unable to modify hotfix"; Severity = "Error" }
  99 = @{ Message = "Unable to modify update"; Severity = "Error" }
  100 = @{ Message = "Unable to modify uninstall"; Severity = "Error" }
  101 = @{ Message = "Unable to modify repair"; Severity = "Error" }
  102 = @{ Message = "Unable to modify configure"; Severity = "Error" }
  103 = @{ Message = "Unable to modify customize"; Severity = "Error" }
  104 = @{ Message = "Unable to modify optimize"; Severity = "Error" }
  105 = @{ Message = "Unable to modify tune"; Severity = "Error" }
  106 = @{ Message = "Unable to modify debug"; Severity = "Error" }
  107 = @{ Message = "Unable to modify test"; Severity = "Error" }
  108 = @{ Message = "Unable to modify verify"; Severity = "Error" }
  109 = @{ Message = "Unable to modify validate"; Severity = "Error" }
  110 = @{ Message = "Unable to modify certify"; Severity = "Error" }
  111 = @{ Message = "Unable to modify approve"; Severity = "Error" }
  112 = @{ Message = "Unable to modify reject"; Severity = "Error" }
  113 = @{ Message = "Unable to modify accept"; Severity = "Error" }
  114 = @{ Message = "Unable to modify decline"; Severity = "Error" }
  115 = @{ Message = "Unable to modify cancel"; Severity = "Error" }
  116 = @{ Message = "Unable to modify pause"; Severity = "Error" }
  117 = @{ Message = "Unable to modify resume"; Severity = "Error" }
  118 = @{ Message = "Unable to modify stop"; Severity = "Error" }
  119 = @{ Message = "Unable to modify start"; Severity = "Error" }
  120 = @{ Message = "Unable to modify restart"; Severity = "Error" }
  121 = @{ Message = "Unable to modify shutdown"; Severity = "Error" }
  122 = @{ Message = "Unable to modify power on"; Severity = "Error" }
  123 = @{ Message = "Unable to modify power off"; Severity = "Error" }
  124 = @{ Message = "Unable to modify suspend"; Severity = "Error" }
  125 = @{ Message = "Unable to modify hibernate"; Severity = "Error" }
  126 = @{ Message = "Unable to modify wake"; Severity = "Error" }
  127 = @{ Message = "Unable to modify sleep"; Severity = "Error" }
  128 = @{ Message = "Unable to modify lock"; Severity = "Error" }
  129 = @{ Message = "Unable to modify unlock"; Severity = "Error" }
  130 = @{ Message = "Unable to modify logon"; Severity = "Error" }
  131 = @{ Message = "Unable to modify logoff"; Severity = "Error" }
  132 = @{ Message = "Unable to modify connect"; Severity = "Error" }
  133 = @{ Message = "Unable to modify disconnect"; Severity = "Error" }
  134 = @{ Message = "Unable to modify mount"; Severity = "Error" }
  135 = @{ Message = "Unable to modify unmount"; Severity = "Error" }
  136 = @{ Message = "Unable to modify format"; Severity = "Error" }
  137 = @{ Message = "Unable to modify partition"; Severity = "Error" }
  138 = @{ Message = "Unable to modify initialize"; Severity = "Error" }
  139 = @{ Message = "Unable to modify deinitialize"; Severity = "Error" }
  140 = @{ Message = "Unable to modify scan"; Severity = "Error" }
  141 = @{ Message = "Unable to modify clean"; Severity = "Error" }
  142 = @{ Message = "Unable to modify defragment"; Severity = "Error" }
  143 = @{ Message = "Unable to modify compact"; Severity = "Error" }
  144 = @{ Message = "Unable to modify expand"; Severity = "Error" }
  145 = @{ Message = "Unable to modify compress"; Severity = "Error" }
  146 = @{ Message = "Unable to modify decompress"; Severity = "Error" }
  147 = @{ Message = "Unable to modify encrypt"; Severity = "Error" }
  148 = @{ Message = "Unable to modify decrypt"; Severity = "Error" }
  149 = @{ Message = "Unable to modify sign"; Severity = "Error" }
  150 = @{ Message = "Unable to modify verify"; Severity = "Error" }
  151 = @{ Message = "Unable to modify authenticate"; Severity = "Error" }
  152 = @{ Message = "Unable to modify authorize"; Severity = "Error" }
  153 = @{ Message = "Unable to modify audit"; Severity = "Error" }
  154 = @{ Message = "Unable to modify monitor"; Severity = "Error" }
  155 = @{ Message = "Unable to modify trace"; Severity = "Error" }
  156 = @{ Message = "Unable to modify log"; Severity = "Error" }
  157 = @{ Message = "Unable to modify report"; Severity = "Error" }
  158 = @{ Message = "Unable to modify alert"; Severity = "Error" }
  159 = @{ Message = "Unable to modify notify"; Severity = "Error" }
  160 = @{ Message = "Unable to modify escalate"; Severity = "Error" }
  161 = @{ Message = "Unable to modify delegate"; Severity = "Error" }
  162 = @{ Message = "Unable to modify assign"; Severity = "Error" }
  163 = @{ Message = "Unable to modify revoke"; Severity = "Error" }
  164 = @{ Message = "Unable to modify grant"; Severity = "Error" }
  165 = @{ Message = "Unable to modify deny"; Severity = "Error" }
  166 = @{ Message = "Unable to modify permit"; Severity = "Error" }
  167 = @{ Message = "Unable to modify forbid"; Severity = "Error" }
  168 = @{ Message = "Unable to modify allow"; Severity = "Error" }
  169 = @{ Message = "Unable to modify restrict"; Severity = "Error" }
  170 = @{ Message = "Unable to modify enable"; Severity = "Error" }
  171 = @{ Message = "Unable to modify disable"; Severity = "Error" }
  172 = @{ Message = "Unable to modify activate"; Severity = "Error" }
  173 = @{ Message = "Unable to modify deactivate"; Severity = "Error" }
  174 = @{ Message = "Unable to modify install"; Severity = "Error" }
  175 = @{ Message = "Unable to modify uninstall"; Severity = "Error" }
  176 = @{ Message = "Unable to modify upgrade"; Severity = "Error" }
  177 = @{ Message = "Unable to modify downgrade"; Severity = "Error" }
  178 = @{ Message = "Unable to modify patch"; Severity = "Error" }
  179 = @{ Message = "Unable to modify hotfix"; Severity = "Error" }
  180 = @{ Message = "Unable to modify update"; Severity = "Error" }
  181 = @{ Message = "Unable to modify repair"; Severity = "Error" }
  182 = @{ Message = "Unable to modify configure"; Severity = "Error" }
  183 = @{ Message = "Unable to modify customize"; Severity = "Error" }
  184 = @{ Message = "Unable to modify optimize"; Severity = "Error" }
  185 = @{ Message = "Unable to modify tune"; Severity = "Error" }
  186 = @{ Message = "Unable to modify debug"; Severity = "Error" }
  187 = @{ Message = "Unable to modify test"; Severity = "Error" }
  188 = @{ Message = "Unable to modify verify"; Severity = "Error" }
  189 = @{ Message = "Unable to modify validate"; Severity = "Error" }
  190 = @{ Message = "Unable to modify certify"; Severity = "Error" }
  191 = @{ Message = "Unable to modify approve"; Severity = "Error" }
  192 = @{ Message = "Unable to modify reject"; Severity = "Error" }
  193 = @{ Message = "Unable to modify accept"; Severity = "Error" }
  194 = @{ Message = "Unable to modify decline"; Severity = "Error" }
  195 = @{ Message = "Unable to modify cancel"; Severity = "Error" }
  196 = @{ Message = "Unable to modify pause"; Severity = "Error" }
  197 = @{ Message = "Unable to modify resume"; Severity = "Error" }
  198 = @{ Message = "Unable to modify stop"; Severity = "Error" }
  199 = @{ Message = "Unable to modify start"; Severity = "Error" }
  200 = @{ Message = "Unable to modify restart"; Severity = "Error" }
  201 = @{ Message = "Unable to modify shutdown"; Severity = "Error" }
  202 = @{ Message = "Unable to modify power on"; Severity = "Error" }
  203 = @{ Message = "Unable to modify power off"; Severity = "Error" }
  204 = @{ Message = "Unable to modify suspend"; Severity = "Error" }
  205 = @{ Message = "Unable to modify hibernate"; Severity = "Error" }
  206 = @{ Message = "Unable to modify wake"; Severity = "Error" }
  207 = @{ Message = "Unable to modify sleep"; Severity = "Error" }
  208 = @{ Message = "Unable to modify lock"; Severity = "Error" }
  209 = @{ Message = "Unable to modify unlock"; Severity = "Error" }
  210 = @{ Message = "Unable to modify logon"; Severity = "Error" }
  211 = @{ Message = "Unable to modify logoff"; Severity = "Error" }
  212 = @{ Message = "Unable to modify connect"; Severity = "Error" }
  213 = @{ Message = "Unable to modify disconnect"; Severity = "Error" }
  214 = @{ Message = "Unable to modify mount"; Severity = "Error" }
  215 = @{ Message = "Unable to modify unmount"; Severity = "Error" }
  216 = @{ Message = "Unable to modify format"; Severity = "Error" }
  217 = @{ Message = "Unable to modify partition"; Severity = "Error" }
  218 = @{ Message = "Unable to modify initialize"; Severity = "Error" }
  219 = @{ Message = "Unable to modify deinitialize"; Severity = "Error" }
  220 = @{ Message = "Unable to modify scan"; Severity = "Error" }
  221 = @{ Message = "Unable to modify clean"; Severity = "Error" }
  222 = @{ Message = "Unable to modify defragment"; Severity = "Error" }
  223 = @{ Message = "Unable to modify compact"; Severity = "Error" }
  224 = @{ Message = "Unable to modify expand"; Severity = "Error" }
  225 = @{ Message = "Unable to modify compress"; Severity = "Error" }
  226 = @{ Message = "Unable to modify decompress"; Severity = "Error" }
  227 = @{ Message = "Unable to modify encrypt"; Severity = "Error" }
  228 = @{ Message = "Unable to modify decrypt"; Severity = "Error" }
  229 = @{ Message = "Unable to modify sign"; Severity = "Error" }
  230 = @{ Message = "Unable to modify verify"; Severity = "Error" }
  231 = @{ Message = "Unable to modify authenticate"; Severity = "Error" }
  232 = @{ Message = "Unable to modify authorize"; Severity = "Error" }
  233 = @{ Message = "Unable to modify audit"; Severity = "Error" }
  234 = @{ Message = "Unable to modify monitor"; Severity = "Error" }
  235 = @{ Message = "Unable to modify trace"; Severity = "Error" }
  236 = @{ Message = "Unable to modify log"; Severity = "Error" }
  237 = @{ Message = "Unable to modify report"; Severity = "Error" }
  238 = @{ Message = "Unable to modify alert"; Severity = "Error" }
  239 = @{ Message = "Unable to modify notify"; Severity = "Error" }
  240 = @{ Message = "Unable to modify escalate"; Severity = "Error" }
  241 = @{ Message = "Unable to modify delegate"; Severity = "Error" }
  242 = @{ Message = "Unable to modify assign"; Severity = "Error" }
  243 = @{ Message = "Unable to modify revoke"; Severity = "Error" }
  244 = @{ Message = "Unable to modify grant"; Severity = "Error" }
  245 = @{ Message = "Unable to modify deny"; Severity = "Error" }
  246 = @{ Message = "Unable to modify permit"; Severity = "Error" }
  247 = @{ Message = "Unable to modify forbid"; Severity = "Error" }
  248 = @{ Message = "Unable to modify allow"; Severity = "Error" }
  249 = @{ Message = "Unable to modify restrict"; Severity = "Error" }
  250 = @{ Message = "Unable to modify enable"; Severity = "Error" }
  251 = @{ Message = "Unable to modify disable"; Severity = "Error" }
  252 = @{ Message = "Unable to modify activate"; Severity = "Error" }
  253 = @{ Message = "Unable to modify deactivate"; Severity = "Error" }
  254 = @{ Message = "Unable to modify install"; Severity = "Error" }
  255 = @{ Message = "Unable to modify uninstall"; Severity = "Error" }
}
