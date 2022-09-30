use nyc_taxi_db
GO

create or ALTER PROCEDURE Silver.usp_silver_trip_type
AS
BEGIN
    IF object_id ('Silver.taxi_zone') is not NULL
    drop EXTERNAL TABLE Silver.trip_type;
    
    CREATE EXTERNAL TABLE Silver.trip_type
    WITH (
    LOCATION = 'Silver/trip_type',
    DATA_SOURCE = nyc_taxi_ds,
    FILE_FORMAT = parquet_file_format
    )
    AS
    SELECT *
    FROM Bronze.trip_type;
    
END;