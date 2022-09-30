use nyc_taxi_db
GO

create or ALTER PROCEDURE Silver.usp_silver_vendor
AS
BEGIN
    IF object_id ('Silver.vendor') is not NULL
    drop EXTERNAL TABLE Silver.vendor;
    
    CREATE EXTERNAL TABLE Silver.vendor
    WITH (
    LOCATION = 'Silver/vendor',
    DATA_SOURCE = nyc_taxi_ds,
    FILE_FORMAT = parquet_file_format
    )
    AS
    SELECT *
    FROM Bronze.vendor;
    
END;