-- File format to read the CSV
create or replace file format frosty_csv
    type = csv
    field_delimiter = ','
    field_optionally_enclosed_by = '"'
    skip_header = 1;
    
-- Creates stage to read the CSV
create or replace stage w22_frosty_stage
  url = 's3://frostyfridaychallenges/challenge_22/'
  file_format = frosty_csv;
  
-- Roles needed for challenge
create role rep1;
create role rep2;

-- Grant roles to self for testing
grant role rep1 to user maiegg;
grant role rep2 to user maiegg;

-- Enable warehouse usage. Assumes that `public` has access to the warehouse
grant role public to role rep1;
grant role public to role rep2;

-- Create the table from the CSV in S3
create table exercises.frosty_friday.week22 as
select t.$1::int id, t.$2::varchar(50) city, t.$3::int district from @w22_frosty_stage (pattern=>'.*sales_areas.*') t;

-- Code for creating the secure view
CREATE OR REPLACE SECURE VIEW exercises.frosty_friday.secure_cities AS
SELECT
    uuid_string() AS id,
    city, 
    district
FROM
    exercises.frosty_friday.week22 
WHERE
    (
        MOD(id, 2) = 1 AND CURRENT_ROLE() = 'REP1'
    )
    OR
    (
        MOD(id, 2) = 0 AND CURRENT_ROLE() = 'REP2'
    );
    
-- Roles need DB access
grant usage on database exercises to role rep1;
grant usage on database exercises to role rep2;
-- And schema access
grant usage on schema exercises.frosty_friday to role rep1;
grant usage on schema exercises.frosty_friday to role rep2;
-- And usage of view
grant select on view exercises.frosty_friday.secure_cities to role rep1;
grant select on view exercises.frosty_friday.secure_cities to role rep2;

-- And usage of warehouse! this was omitted in template 
use role accountadmin;
grant usage on warehouse compute_wh to role rep1;
grant usage on warehouse compute_wh to role rep2;

-- Get the result of queries
use role rep1;
select * from exercises.frosty_friday.secure_cities;

use role rep2;
select * from exercises.frosty_friday.secure_cities;
