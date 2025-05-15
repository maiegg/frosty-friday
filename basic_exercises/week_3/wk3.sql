
create or replace stage s3_data 
	URL = 's3://frostyfridaychallenges/challenge_3/' 
	directory = ( enable = true )
     file_format = (
        TYPE = CSV
        SKIP_HEADER = 1
    );

create or replace temporary file format csv_ff
    type = csv,
    skip_header = 1,
    field_optionally_enclosed_by = '"'
;
create or replace table wk3_keywords as 
select $1 as keyword 
FROM @s3_data/keywords.csv (FILE_FORMAT => csv_ff) t;

with wk3_files as (
    SELECT
        metadata$filename AS filename
        , COUNT(*) AS number_of_rows
    FROM @s3_data
    group by filename
),
joined_table as (
    select files.*
    , keywords.*
    from wk3_files files 
    cross join wk3_keywords keywords
)

select filename, number_of_rows
from joined_table
where filename ILIKE '%' || keyword || '%';