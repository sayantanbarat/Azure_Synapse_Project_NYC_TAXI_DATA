use nyc_taxi_db
GO

create or ALTER PROCEDURE Silver.usp_silver_calendar
AS
BEGIN
    IF object_id ('Silver.calendar') is not NULL
    drop EXTERNAL TABLE Silver.calendar;
    
    CREATE EXTERNAL TABLE Silver.calendar
    WITH (
    LOCATION = 'Silver/calendar',
    DATA_SOURCE = nyc_taxi_ds,
    FILE_FORMAT = parquet_file_format
    )
    AS
    SELECT *
    FROM Bronze.calendar;
    
END;