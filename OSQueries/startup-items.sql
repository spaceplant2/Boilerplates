/*
 *  This should be pretty self-explanatory. It is also useful for seeing which profiles are loaded.
 *  See also tables autoexec, scheduled_tasks, startup_items, services
 *  System impact is extremely high.
 */

SELECT name AS Item,
  type,
  username AS 'Run As',
  path,
  args,
  status,
  source
FROM startup_items