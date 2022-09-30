use nyc_taxi_db;

select 
td.year,
td.month,
tz.Borough,
convert(date,td.lpep_pickup_datetime) as trip_date,
cal.day_name as trip_day,
case WHEN cal.day_name in ('Saturday','Sunday') then 'Y' else 'N' end as trip_weekend_day_ind,
sum(case when pt.description='Credit card' Then 1 else 0 end) as card_trip_count,
sum(case when pt.description='Cash' then 1 else 0 END) as cash_trip_count
from Silver.vw_trip_data_green td
join Silver.taxi_zone tz on (td.pulocation_id=tz.LocationID)
join Silver.calendar cal on (convert(DATE,td.lpep_pickup_datetime)=cal.date)
join Silver.payment_type pt on (td.payment_type=td.payment_type)
where td.year='2020'
and td.month='01'
group by 
td.year,
td.month,
tz.Borough,
convert(date,td.lpep_pickup_datetime) ,
cal.day_name 