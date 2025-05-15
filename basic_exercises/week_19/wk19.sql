CREATE OR REPLACE TABLE date_dim AS
WITH RECURSIVE CalendarDates AS (
SELECT DATE('2000-01-01') AS calendar_date
UNION ALL
SELECT DATEADD(DAY, 1, calendar_date)
FROM CalendarDates
WHERE calendar_date <= '2100-01-01'
)
select 

    calendar_date
    , YEAR(calendar_date) as calendar_year
    , MONTHNAME(calendar_date) as month_abbrev
    , TO_CHAR(calendar_date,'MMMM') as month_name
    , MONTH(calendar_date) AS month_number
    , DAY(calendar_date) AS day_of_month
    , DAYOFWEEK(calendar_date) AS day_of_week -- 0-6, 0 = Sunday by default 
    , WEEK(calendar_date) AS week_of_year
    , DAYOFYEAR(calendar_date) AS day_of_year
from CALENDARDATES
;


select min(calendar_date), max(calendar_date)
from date_dim;

create function weekdays_between_dates(start_date date, end_date date)
    RETURNS number
    AS 
    $$
    WITH RECURSIVE CalendarDates AS (
    SELECT DATE(start_date) AS calendar_date
    UNION ALL
    SELECT DATEADD(DAY, 1, calendar_date)
    FROM CalendarDates
    WHERE calendar_date <= end_date
    )
    select sum(
    case when DAYOFWEEK(calendar_date) in (6,0) then 0 else 1 end
    )
    from CalendarDates
    $$
;


select weekdays_between_dates('2025-04-26', '2025-05-02');