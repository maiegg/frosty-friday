

**Start with a dummy table**

The challenge doesn't specify any input args, and just asks us to create an input table with any values.

```
create table wk5
( 
    start_int number
);

insert into wk5(start_int)
values
(3)
,(4)
,(5)
;
```

**Write the UDF**

Then, we define a SQL UDF according to the syntax specified in Snowflake docs:
```
create function timesthree(start_int number)
    RETURNS number
    AS 
    $$
    start_int * 3
    $$
;
```
We can also do this in Python:
```
create function timesthree_in_python(start_int number)
    RETURNS INT
    LANGUAGE PYTHON
    RUNTIME_VERSION = '3.9'
    HANDLER = 'timesthree_py'
    AS $$
    def timesthree_py(i):
    return i*3
    $$
;
```

To complete the challenge, we simply display results:
```
select start_int, timesthree(start_int) as end_int
from wk5;
```