/*    This set should pretty much give a big-picture view of user activities. 
 *  each query against a table should be joined (or unioned) to the next
 *  Why is getting logon events so complicated???
 */

select * from account_policy_data
select * from groups
select * from logged_in_users
select * from known_hosts
select user,logon_domain,logon_type,logon_time,logon_server from logon_sessions
select * from userassist

//  These two tables are pretty close to equivalent
select * from windows_eventlog where eventid = ''
select * from windows_events where eid = ''