use nyc_taxi_db
GO

create or ALTER PROCEDURE Silver.usp_silver_rate_code
AS
BEGIN
    IF object_id ('Silver.rate_code') is not NULL
    drop EXTERNAL TABLE Silver.rate_code;
    
    CREATE EXTERNAL TABLE Silver.rate_code
    WITH (
    LOCATION = 'Silver/rate_code',
    DATA_SOURCE = nyc_taxi_ds,
    FILE_FORMAT = parquet_file_format
    )
    AS
    select  rate_code_id, rate_code from 
OPENROWSET(
    BULK 'raw/rate_code.json',
    FORMAT='CSV',
    DATA_SOURCE='nyc_taxi_ds',
    FIELDTERMINATOR='0x0b',
    FIELDQUOTE='0x0b',
    ROWTERMINATOR='0x0b'

)WITH(
    jsondoc NVARCHAR(MAX)
    
) as [result]
CROSS APPLY openjson(jsondoc)
WITH(
    rate_code_id SMALLINT,
    rate_code varchar(35) 
);
    
END;