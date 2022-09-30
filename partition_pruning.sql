create or ALTER PROCEDURE Silver.partion_procedure
@year VARCHAR(4),
@month VARCHAR(2)
AS
BEGIN
DECLARE
@create_sql_stmt NVARCHAR(MAX),
@drop_sql_stmt NVARCHAR(MAX)
set @create_sql_stmt=
'create external table Silver.trip_data_green_'+@year+'_'+@month+
' WITH (
    DATA_SOURCE=nyc_taxi_ds,
    LOCATION=''Silver/trip_data_green/year='+@year+'/month='+@month+''',
    FILE_FORMAT=parquet_file_format

)
AS 
select  [VendorID] as vendor_id,
    [lpep_pickup_datetime] ,
    [lpep_dropoff_datetime] ,
    [store_and_fwd_flag] ,
    [RatecodeID] as ratecode_id,
    [PULocationID] as pulocation_id,
    [DOLocationID] as dolocation_id,
    [passenger_count] ,
    [trip_distance] ,
    [fare_amount] ,
    [extra] ,
    [mta_tax] ,
    [tip_amount] ,
    [tolls_amount] ,
    [ehail_fee] ,
    [improvement_surcharge] ,
    [total_amount] ,
    [payment_type] ,
    [trip_type] ,
    [congestion_surcharge] 
    from Bronze.vw_trip_data_green_csv
where year='''+@year+'''
and month='''+@month+'''';
PRINT(@create_sql_stmt)
exec sp_executesql @create_sql_stmt;
set @drop_sql_stmt=
'drop external table Silver.trip_data_green_'+@year+'_'+@month;

PRINT(@drop_sql_stmt)
EXEC sp_executesql @drop_sql_stmt;
END