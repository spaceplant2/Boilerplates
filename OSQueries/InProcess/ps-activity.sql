/*
 *  Logging will need to be enabled before these events will actually exist.
 *  Also check out this brilliant search that grabs the log of all commands put into PS:
 *  https://github.com/SophosRapidResponse/OSQuery/blob/main/Testing/PowerShell/RR%20-%20PowerShell%20Console%20logs.txt
 *
 *  working with tables windows_eventlog and windows_events
 */

SELECT computer_name AS Hostname,
      datetime AS Time,
      task,
      level AS 'Security Level',
      provider_name,
      eventid,
      data

  FROM windows_events
  where ((eid = '4104') or (eid = '4103') or 
      (eid = '25438') or (eid = '25507') or (eid = '25564') or (eid = '25595')
  )
