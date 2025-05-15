-- Set the database and schema
use database exercises;
use schema frosty_friday;
use role accountadmin;

create or replace file format csv_ff
    type = csv,
    skip_header = 1
;

DROP TASK IF EXISTS skim_milk_updates;
DROP TASK IF EXISTS whole_milk_updates;

-- Create the stage that points at the data.
create or replace stage week_11_frosty_stage
    url = 's3://frostyfridaychallenges/challenge_11/'
    file_format = csv_ff;

-- Create the table as a CTAS statement.
create or replace table week11 as
select TO_TIMESTAMP(m.$1) as milking_datetime,
        m.$2 as cow_number,
        CAST(m.$3 AS NUMBER) as fat_percentage,
        m.$4 as farm_code,
        TO_TIMESTAMP(m.$5) as centrifuge_start_time,
        TO_TIMESTAMP(m.$6) as centrifuge_end_time,
        m.$7 as centrifuge_kwph,
        m.$8 as centrifuge_electricity_used,
        m.$9 as centrifuge_processing_time,
        NULLIF(m.$10,'NULL') as task_used
from @week_11_frosty_stage (file_format => 'csv_ff', pattern => '.*milk_data.*[.]csv') m;


-- TASK 1: Remove all the centrifuge dates and centrifuge kwph and replace them with NULLs WHERE fat = 3. 
-- Add note to task_used.
CREATE OR REPLACE TASK whole_milk_updates
AS
UPDATE week11 
SET 
    centrifuge_start_time = NULL,
    centrifuge_end_time = NULL,
    centrifuge_kwph = NULL,
    task_used = COALESCE(task_used, '') || ' Updated centrifuge dates and kwph to null where fat = 3.'
WHERE fat_percentage = 3;

-- TASK 2: Calculate centrifuge processing time (difference between start and end time) WHERE fat != 3. 
-- Add note to task_used.
CREATE OR REPLACE TASK skim_milk_updates 
AS 
UPDATE week11
SET 
    centrifuge_processing_time = DATEDIFF('second'
        , centrifuge_start_time
        , centrifuge_end_time
        ),
    task_used = COALESCE(task_used, '') || ' Added centrifuge processing time where fat != 3.'
WHERE fat_percentage != 3;

-- Manually execute the task.
execute task whole_milk_updates;
execute task skim_milk_updates;


-- Check that the data looks as it should.
select *
from 
(select * from week11 where fat_percentage = 3 limit 5)
union 
(select * from week11 where fat_percentage != 3 limit 5);
