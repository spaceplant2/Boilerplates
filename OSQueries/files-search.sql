/*    Not quite what I was after. This gives a single result per endpoint, and Count(*) might be the
 *       only useful piece of information so far. Also problematic that OSQuery is unable to find hidden files.
 *    Change the value of @path to the desired location. '%' is used for wildcard, and '%%' for
 *    recursive wildcard. Remember the single quotes areound the path, especially if spaces or wildcards are included.
 */

set @path = '\Users\%\2222\%%'

select count(*),path,inode,uid,gid,mode,size,datetime(atime,'unixepoch') AS atime,datetime(mtime,'unixepoch') AS mtime,hard_links,symlink,type,attributes
from file
where path like @path;
