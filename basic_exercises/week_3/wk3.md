

**Same as before: create external stage**
```
create or replace stage s3_data 
	URL = 's3://frostyfridaychallenges/challenge_3/' 
	directory = ( enable = true )
     file_format = (
        TYPE = CSV
        SKIP_HEADER = 1
    );
```
**Create a reference table for our keywords**

Same as before, we will manually define a file format base on known or assumed file contents.

```
create or replace temporary file format csv_ff
    type = csv,
    skip_header = 1,
    field_optionally_enclosed_by = '"'
;
create or replace table wk3_keywords as 
select $1 as keyword 
FROM @s3_data/keywords.csv (FILE_FORMAT => csv_ff) t;
```

Since I want to compare these row-wise with the contents of another table containing filenames (yet to be created), aggregate this onto a single row. 

I'm not sure if this will really be more space-efficient than keeping the keywords table long and doing a cross-join, but maybe we can explore that later. 
```
create or replace table wk3_keywords as 
select array_agg(keyword) as keywords
from wk3_keywords;
```

**Compare filenames to keywords**
We do a couple things in this expression:
+ use the automatic `metadata$filename` associated with the S3 stage to get file names 
+ get row count of each file
+ compare filenames to the list of keywords
+ keep only rows with matches, and select the filename and row count

```

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
```

| FILENAME                                   | NUMBER_OF_ROWS |
|--------------------------------------------|----|
| challenge_3/week3_data2_stacy_forgot_to_upload.csv | 11 |
| challenge_3/week3_data4_extra.csv           | 12 |
| challenge_3/week3_data5_added.csv           | 13 |
