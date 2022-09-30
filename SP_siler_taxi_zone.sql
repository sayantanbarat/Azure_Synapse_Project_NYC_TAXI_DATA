use nyc_taxi_db
GO

create or ALTER PROCEDURE Silver.sp_taxi_zone
AS
BEGIN
    IF object_id ('Silver.taxi_zone') is not NULL
    drop EXTERNAL TABLE Silver.taxi_zone;
    
    CREATE EXTERNAL TABLE Silver.taxi_zone
    WITH (
    LOCATION = 'Silver/taxi_zone',
    DATA_SOURCE = nyc_taxi_ds,
    FILE_FORMAT = parquet_file_format
    )
    AS
    SELECT *
    FROM Bronze.taxi_zone;
    
END;