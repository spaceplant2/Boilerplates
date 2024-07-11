/*
 *  Check on disk health.
 */
 
 select physical_disk_performance.name,
    physical_disk_performance.avg_disk_sec_per_read AS 'Avg Read Time',
    physical_disk_performance.avg_disk_sec_per_write AS 'Avg Write Time',
    physical_disk_performance.percent_disk_time AS 'Busy',
    physical_disk_performance.percent_idle_time AS 'Idle',
    disk_info.partitions,
    disk_info.id,
    (disk_info.disk_size / 1048576) AS 'Disk Size MB',
    (logical_drives.free_space / 1048576) AS 'Free Space MB',
    logical_drives.description

from physical_disk_performance
join disk_info
join logical_drives
