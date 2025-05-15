>   FrostyFriday Inc., your benevolent employer, has an S3 bucket that is filled with .csv data dumps. 
    This data is needed for analysis. Your task is to create an external stage, and load the csv files 
    directly from that stage into a table.
    The S3 bucket’s URI is: s3://frostyfridaychallenges/challenge_1/
    
**Create external stage**

```
create or replace stage s3_data 
	URL = 's3://frostyfridaychallenges/challenge_1/' 
	directory = ( enable = true );
    
list @s3_data;
```

**Read files into table**

To do this the way tutorials recommend, you need to know the schema ahead of time. I think there are workarounds for this, but I will download a file and preview it to infer the schema:

`curl 'http://frostyfridaychallenges.s3.amazonaws.com/challenge_1/1.csv'` 

It looks like there is a header row called `result` and a single column of data.

```
-- file format 
create or replace file format csv_ff
    type = csv,
    skip_header = 1
;

-- create table 
create or replace table exercises.frosty_friday.wk1(
    result varchar,
    filename varchar,
    file_row_number int
);

-- copy into table 
copy into wk1 from (
    select $1 as message
        , metadata$filename
        , metadata$file_row_number 
    from @s3_data (file_format=>'csv_ff')
);
```

**View result**
There are some oddities in here! The result, exactly as on S3, reads: 

| RESULT            |
|-------------------|
| you               |
| have              |
| gotten            |
| it                |
| right             |
| NULL              |
| totally_empty     |
| congratulations!  |

Seems like a few of those don't belong :) So edit the file format to recognize those values as null by adding this line:
`NULL_IF = ('NULL', 'totally_empty')`

And edit our final select statement to exclude those nulls:

```
select result
from wk1 
where result is not null
order by filename, file_row_number asc;
```

Which gives us this:
| RESULT            |
|-------------------|
| you               |
| have              |
| gotten            |
| it                |
| right             |
| congratulations!  |