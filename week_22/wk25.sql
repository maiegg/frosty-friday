use database exercises;
use schema frosty_friday; 
use role accountadmin;

-- 1. Create a stage for the landing layer and copy the JSON. 
create or replace stage s3_data 
	URL = 's3://frostyfridaychallenges/challenge_25/' ;

create or replace table weather_raw (
    rawdata variant 
);

copy into weather_raw 
from @s3_data 
file_format = (type='JSON');


-- 2. Parse the JSON and create a table – weather_parsed (in the curated zone). 

-- there are 2 top-level keys: sources, weather 
select object_keys(rawdata) from weather_raw;

-- What about the next level down? 

select object_keys(value)
from weather_raw
, LATERAL FLATTEN(input => PARSE_JSON(rawdata):weather);
-- [
--   "cloud_cover",
--   "condition",
--   "dew_point",
--   "fallback_source_ids",
--   "icon",
--   "precipitation",
--   "pressure_msl",
--   "relative_humidity",
--   "source_id",
--   "sunshine",
--   "temperature",
--   "timestamp",
--   "visibility",
--   "wind_direction",
--   "wind_gust_direction",
--   "wind_gust_speed",
--   "wind_speed"
-- ]


select object_keys(value)
from weather_raw
, LATERAL FLATTEN(input => PARSE_JSON(rawdata):sources);

-- [
--   "distance",
--   "dwd_station_id",
--   "first_record",
--   "height",
--   "id",
--   "last_record",
--   "lat",
--   "lon",
--   "observation_type",
--   "station_name",
--   "wmo_station_id"
-- ]


-- Our output should have at a minimum: 
-- Date, icon_array, avg_temperature, total_precipitation, avg_wind, avg_humidity 
-- It looks like htese can all be found in the `weather` object.


create or replace table weather_curated as 
select value:timestamp::timestamp as timestamp
, date(value:timestamp::timestamp) as timestamp_date
, value:temperature::number as temperature
, value:precipitation::number as precipitation
, value:wind_speed::number as wind_speed
, value:relative_humidity::int as relative_humidity 
, value:icon::text as icon 
from weather_raw
, LATERAL FLATTEN(input => PARSE_JSON(rawdata):weather);

-- 3. Create a table for consumption weather_agg (in the consumption zone).     
-- The table should have aggregates per day for: 
-- a. Temperature       
-- b. Wind speed       
-- c. Distinct ‘icon’ definitions for a day (e.g. [“cloudy”, “rain”]

create or replace table weather_aggregated as 
select timestamp_date
, array_agg(icon) as icon_array
, avg(temperature) as avg_temperature
, sum(precipitation) as total_precipitation
, avg(wind_speed) as avg_wind_speed 
, avg(relative_humidity) as avg_humidity
from weather_curated
group by 1
order by 1;


select *
from weather_aggregated
limit 10;