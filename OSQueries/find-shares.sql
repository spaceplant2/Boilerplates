/*
 *  Useful for making sure there isn't illegal resource sharing happening. Note that this will show
 *    connections that were made to legitimate shares, so add an exclusion for each shared resource
 *    that a local machine is allowed to connect to. This can get interesting...
 */

SELECT description,
  install_date,
  status,
  name,
  path,
  type_name

from shared_resources
where (path not like '%myNas01%')