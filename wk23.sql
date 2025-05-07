-- Log into your account in snow sql: 
-- snowsql -a <account_identifier> -u <your_username>

USE DATABASE exercises;
USE SCHEMA frosty_friday;

-- Create table (can be done from within snowsql)
CREATE OR REPLACE TABLE wk23 (
    id INT
    , first_name VARCHAR(50)
    , last_name VARCHAR(50) 
    , email VARCHAR(100)
    , gender VARCHAR(10)
    , ip_address VARCHAR(20)
);


-- Load files using table stage and a wildcard pattern
-- put file://downloads/splitcsv-c18c2b43-ca57-4e6e-8d95-f2a689335892-results/*1.csv @%wk23;


-- Load data from stage into a table using an on-the-fly file format 
COPY INTO wk23
FROM @%wk23
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY='"' SKIP_HEADER=1)
ON_ERROR = 'SKIP_FILE';
