#!bin/bash
HIVE_HOME=/opt/cdh/hive-1.1.0-cdh5.16.2
DB=gmall

if [ -n $1 ];then 
    do_date=$1
    echo $do_date
else
    do_date=`date -d  "-1 day" +%F`
    echo $do_date
fi

sql="insert overwrite  table $DB.dwd_start_log partition (dt='$do_date')
select
get_json_object(line, '$.cid')  client_id,
get_json_object(line, '$.uid')  user_id,
get_json_object(line, '$.ar')  area,
get_json_object(line, '$.ip')  ip,
get_json_object(line, '$.ct')  client_type,
get_json_object(line, '$.sc')  screen,
get_json_object(line, '$.lal')  lal,
get_json_object(line, '$.os')  os,
get_json_object(line, '$.la')  la,
get_json_object(line, '$.ne')  network,
get_json_object(line, '$.vc')  version_code,
get_json_object(line, '$.sv')  sdk_version,
get_json_object(line, '$.so')  source,
get_json_object(line, '$.t')  create_time,
get_json_object(line, '$.ev')  event_type,
get_json_object(line, '$.en')  entry,
get_json_object(line, '$.lt')  load_time,
get_json_object(line, '$.ac')  action,
get_json_object(line, '$.ic')  ad_code,
get_json_object(line, '$.de')  detail,
get_json_object(line, '$.ex1')  extend1
from $DB.ods_start_log where dt='$do_date';
"

$HIVE_HOME/bin/hive -e "$sql"
