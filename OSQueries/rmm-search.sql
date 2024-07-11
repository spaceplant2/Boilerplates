/*
 *    Find RMM tools. This could be used to find pretty much *any* legitimately installed tool as well.
 */

SELECT * FROM
(
  SELECT
    name,
    version AS 'Version',
    install_date AS 'Install Date',
    install_location AS 'Install Location',
    install_source AS 'Install Source',
    '' AS 'Auto Launch',
    publisher AS 'Publisher',
    uninstall_string AS 'Uninstall'
  FROM programs

  UNION ALL

  SELECT
    '' AS 'Name',
    '' AS 'Version',
    '' AS 'Install Date',
    '' AS 'Install Location',
    '' AS 'Install Source',
    name AS 'Auto Launch',
    '' AS 'Publisher',
    '' AS 'Uninstall String'
  FROM autoexec
)
WHERE
  name LIKE '%action1%'
  OR name LIKE '%Ammyy%'
  OR name LIKE '%AnyDesk%'
  OR name LIKE '%Atera%'
  OR name LIKE '%Dameware%'
  OR name LIKE '%GoToAssist%'
  OR name LIKE '%Intelliadmin%'
  OR name LIKE '%Kaseya%'
  OR name LIKE '%LogMeIn%'
  OR name LIKE '%meshcentral%'
  OR name LIKE '%NetSupport%'
  OR name LIKE '%Radmin%'
  OR name LIKE '%Remote%'
  OR name LIKE '%RemotePC%'
  OR name LIKE '%remotepc%'
  OR name LIKE '%rustdesk%'
  OR name LIKE '%ScreenConnect%'
  OR name LIKE '%Simple%help%'
  OR name LIKE '%Splashtop%'
  OR name LIKE '%SupRemo%'
  OR name LIKE '%tacticalrmm%'
  OR name LIKE '%TeamViewer%'
  OR name LIKE '%UltraViewer%'
  OR name LIKE '%VNC%'
