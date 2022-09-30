create or alter PROCEDURE Gold.gold_procedure
@year VARCHAR(4),
@month VARCHAR(2)
AS
BEGIN
DECLARE
@create_sql_stmt NVARCHAR(MAX),
@drop_sql_stmt NVARCHAR(MAX)
set @create_sql_stmt=
'create external table Gold.trip_data_green_'+@year+'_'+@month+
' WITH (
    DATA_SOURCE=nyc_taxi_ds,
    LOCATION=''Gold/trip_data_green/year='+@year+'/month='+@month+''',
    FILE_FORMAT=parquet_file_format

)
AS 
select 
td.year,
td.month,
tz.Borough,
convert(date,td.lpep_pickup_datetime) as trip_date,
cal.day_name as trip_day,
case WHEN cal.day_name in (''Saturday'',''Sunday'') then ''Y'' else ''N'' end as trip_weekend_day_ind,
sum(case when pt.description=''Credit card'' Then 1 else 0 end) as card_trip_count,
sum(case when pt.description=''Cash'' then 1 else 0 END) as cash_trip_count,
sum(case when tt.vendor_name=''Street-hail'' then 1 else 0 end) as trip_count_street_hail,
sum(case when tt.vendor_name=''Dispatch'' then 1 else 0 end)as trip_count_dispatch
from Silver.vw_trip_data_green td
join Silver.taxi_zone tz on (td.pulocation_id=tz.LocationID)
join Silver.calendar cal on (convert(DATE,td.lpep_pickup_datetime)=cal.date)
join Silver.payment_type pt on (td.payment_type=td.payment_type)
join Silver.trip_type tt on (td.trip_type=tt.vendor_id)
where td.year='''+@year+'''
and td.month='''+@month+'''
group by 
td.year,
td.month,
tz.Borough,
convert(date,td.lpep_pickup_datetime) ,
cal.day_name';
PRINT(@create_sql_stmt)
exec sp_executesql @create_sql_stmt;
set @drop_sql_stmt=
'drop external table Gold.trip_data_green_'+@year+'_'+@month;

PRINT(@drop_sql_stmt)
EXEC sp_executesql @drop_sql_stmt;
END