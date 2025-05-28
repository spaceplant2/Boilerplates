###   Quick and dirty remediation for not-yet-solved issues
. \\kim-fs1\Public\IT\mreed\CADinstalls\cadInstalls.ps1

#   Open all necessary documentations (licenses, setup instructions, etc)
function OpenLicenseDocs {
  Invoke-Item "$server\Automox\automox_unique_user_key.txt"
  Invoke-Item "$server\Cyberark\CyberArk25.2.0.2476\InstallKey25.2.txt"
  Invoke-Item "$server\PhishAlert\PhishAlert-License Key.txt"
}

#   Copy self-deleting installers to local drive
function CopySelfDeletingInstallers {
    ###   copy self-deleting installers
  Copy-Item "$Server\Adobe\Acrobat_Reader_en_install.exe" -Destination "~/Acrobat_Reader_en_install.exe"
  Copy-Item "$Server\Bomgar\bomgar-scc-w0eec30yzz7gewzy5gj78fg5hgfejzx5hizd6fic40hc90.exe" -Destination "~/bomgar-scc-w0eec30yzz7gewzy5gj78fg5hgfejzx5hizd6fic40hc90.exe"
}