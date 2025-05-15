use schema exercises.frosty_friday;

create or replace stage s3_data 
	URL = 's3://frostyfridaychallenges/challenge_1/' 
	directory = ( enable = true );
    
-- file format 
create or replace file format csv_ff
    type = csv,
    skip_header = 1,
    NULL_IF = ('NULL', 'totally_empty')
;

-- create table 
create or replace table exercises.frosty_friday.wk1(
    result varchar,
    filename varchar,
    file_row_number int
);

-- copy into table 
copy into wk1 from (
    select $1 as result
        , metadata$filename
        , metadata$file_row_number 
    from @s3_data (file_format=>'csv_ff')
);

select result
from wk1 
where result is not null
order by filename, file_row_number asc;

