
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

create function timesthree(start_int number)
    RETURNS number
    AS 
    $$
    start_int * 3
    $$
;

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

select start_int, timesthree_in_python(start_int) as end_int
from wk5;