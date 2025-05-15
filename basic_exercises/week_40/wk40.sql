use role accountadmin; 

-- here is the (un-aggregated) result as a select statement: 
select r.r_name
    , n.n_name 
    , l.l-quantity * l.L_EXTENDEDPRICE * (1-l.L_DISCOUNT) as revenue 
from SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.lineitem l
left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.orders o
    on l.l_orderkey = o.o_orderkey
left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.customer c 
    on o.o_custkey = c.c_custkey    
left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.nation n 
    on c.c_nationkey = n.n_nationkey
left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.region r 
    on r.r_regionkey = n.n_regionkey
where r.r_name = 'EUROPE';

-- The challenge askses for a function:
create or replace function wk38_function()
    returns nubmer(38,2)
    memoizable 
    as 
    $$
    select sum(l.l-quantity * l.L_EXTENDEDPRICE * (1-l.L_DISCOUNT)) as revenue 
    from SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.lineitem l
    left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.orders o
        on l.l_orderkey = o.o_orderkey
    left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.customer c 
        on o.o_custkey = c.c_custkey    
    left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.nation n 
        on c.c_nationkey = n.n_nationkey
    left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.region r 
        on r.r_regionkey = n.n_regionkey
    where r.r_name = 'EUROPE'
    $$ 
    ;

select wk38_function();