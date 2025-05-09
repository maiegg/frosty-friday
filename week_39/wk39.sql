use role accountadmin; 

create or replace table customer_deets (
    id int,
    name string,
    email string
);

insert into customer_deets values
    (1, 'Jeff Jeffy', 'jeff.jeffy121@gmail.com'),
    (2, 'Kyle Knight', 'kyleisdabest@hotmail.com'),
    (3, 'Spring Hall', 'hall.yay@gmail.com'),
    (4, 'Dr Holly Ray', 'drdr@yahoo.com');

-- Here's the challenge bit: 
create or replace masking policy customer_emails
  as (input_string string) returns string ->
  case when current_role() = 'ACCOUNTADMIN'
    then input_string
    else regexp_replace(input_string,'.+\\@','*****@')
  end
;

alter table customer_deets
alter column email set masking policy customer_emails
;
-- -- end challenge bit

select * from customer_deets;
-- OK, see the full address 

-- Grant privileges as switch roles
grant all on customer_deets to sysadmin;
use role sysadmin;

select * from customer_deets;
-- OK, see the masked address 