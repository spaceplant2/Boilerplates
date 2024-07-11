/*
 *  Useful info for building an inventory. The domain_name item is a little wonky though. This is getting 
 *      a little large - take performance into consideration before running this.
 */

SELECT
    system_info.hostname,
    system_info.cpu_brand,
    system_info.cpu_type,
    (system_info.physical_memory / 1048576) AS RAM,
    secureboot.secure_boot,
    battery.health,
    tpm_info.enabled,
    disk_info.manufacturer,
    (disk_info.disk_size /1048576) AS 'Disk Size',
    video_info.manufacturer,
    video_info.model,
    video_info.series,
    system_info.hardware_vendor,
    system_info.hardware_model,
    system_info.hardware_serial,
    os_version.name AS os_name,
    os_version.version AS os_version,
    os_version.build,
    os_version.patch,
    ntdomains.domain_name,
    windows_security_center.firewall,
    windows_security_center.autoupdate,
    windows_security_center.antivirus,
    windows_security_center.user_account_control AS UAC,
    concat(uptime.days, ':', uptime.hours, ':',uptime.minutes) AS uptime
FROM system_info
CROSS JOIN os_version
CROSS JOIN uptime
CROSS JOIN time
CROSS JOIN secureboot
CROSS JOIN disk_info
CROSS JOIN battery
CROSS JOIN ntdomains
CROSS JOIN tpm_info
CROSS JOIN video_info
CROSS JOIN windows_security_center

