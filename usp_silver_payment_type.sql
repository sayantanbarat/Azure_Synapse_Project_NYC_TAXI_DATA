use nyc_taxi_db
GO

create or ALTER PROCEDURE Silver.usp_silver_payment_type
AS
BEGIN
    IF object_id ('Silver.payment_type') is not NULL
    drop EXTERNAL TABLE Silver.payment_type;
    
    CREATE EXTERNAL TABLE Silver.payment_type
    WITH (
    LOCATION = 'Silver/payment_type',
    DATA_SOURCE = nyc_taxi_ds,
    FILE_FORMAT = parquet_file_format
    )
    AS
   select  payment_type, description from 
OPENROWSET(
    BULK 'raw\payment_type.json',
    FORMAT='CSV',
    DATA_SOURCE='nyc_taxi_ds',
    PARSER_VERSION='1.0',
    FIELDTERMINATOR='0x0b',
    FIELDQUOTE='0x0b',
    ROWTERMINATOR='0x0a'

)WITH(
    jsondoc NVARCHAR(MAX)
    
) as [result]
CROSS APPLY openjson(jsondoc)
WITH(
    payment_type SMALLINT,
    description varchar(15) '$.payment_type_desc'
);
    
END;